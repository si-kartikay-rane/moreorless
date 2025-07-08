//
//  PopupHelper.swift
//  QuizeApp
//
//  Created by Vishal Vijayvargiya on 21/08/23.
//

import SwiftUI
import Combine

struct PopupsState {
    var showingMiddle = false
    var showingBottomFirst = false
    var showingBottomSecond = false
}

extension View {

    public func popup<Item: Equatable, PopupContent: View>(
        item: Binding<Item?>,
        type: Popup<Item, PopupContent>.PopupType = .`default`,
        position: Popup<Item, PopupContent>.Position = .bottom,
        animation: Animation = Animation.easeOut(duration: 0.3),
        autohideIn: Double? = nil,
        dragToDismiss: Bool = true,
        closeOnTap: Bool = true,
        closeOnTapOutside: Bool = false,
        backgroundColor: Color = Color.clear,
        dismissCallback: @escaping () -> () = {},
        @ViewBuilder view: @escaping (Item) -> PopupContent) -> some View {
            self.modifier(
                Popup(
                    item: item,
                    type: type,
                    position: position,
                    animation: animation,
                    autohideIn: autohideIn,
                    dragToDismiss: dragToDismiss,
                    closeOnTap: closeOnTap,
                    closeOnTapOutside: closeOnTapOutside,
                    backgroundColor: backgroundColor,
                    dismissCallback: dismissCallback,
                    view: view)
            )
        }

    public func popup<PopupContent: View>(
        isPresented: Binding<Bool>,
        type: Popup<Int, PopupContent>.PopupType = .`default`,
        position: Popup<Int, PopupContent>.Position = .bottom,
        animation: Animation = Animation.easeOut(duration: 0.3),
        autohideIn: Double? = nil,
        dragToDismiss: Bool = true,
        closeOnTap: Bool = true,
        closeOnTapOutside: Bool = false,
        backgroundColor: Color = Color.clear,
        dismissCallback: @escaping () -> () = {},
        @ViewBuilder view: @escaping () -> PopupContent) -> some View {
        self.modifier(
            Popup<Int, PopupContent>(
                isPresented: isPresented,
                type: type,
                position: position,
                animation: animation,
                autohideIn: autohideIn,
                dragToDismiss: dragToDismiss,
                closeOnTap: closeOnTap,
                closeOnTapOutside: closeOnTapOutside,
                backgroundColor: backgroundColor,
                dismissCallback: dismissCallback,
                view: view)
        )
    }

    @ViewBuilder
    func applyIf<T: View>(_ condition: Bool, apply: (Self) -> T) -> some View {
        if condition {
            apply(self)
        } else {
            self
        }
    }

    @ViewBuilder
    fileprivate func addTapIfNotTV(if condition: Bool, onTap: @escaping ()->()) -> some View {
        #if os(tvOS)
        self
        #else
        if condition {
            self.simultaneousGesture(
                TapGesture().onEnded {
                    onTap()
                }
            )
        } else {
            self
        }
        #endif
    }
}

public struct Popup<Item: Equatable, PopupContent: View>: ViewModifier {
    
    init(isPresented: Binding<Bool>,
         type: PopupType,
         position: Position,
         animation: Animation,
         autohideIn: Double?,
         dragToDismiss: Bool,
         closeOnTap: Bool,
         closeOnTapOutside: Bool,
         backgroundColor: Color,
         dismissCallback: @escaping () -> (),
         view: @escaping () -> PopupContent) {
        self._isPresented = isPresented
        self._item = .constant(nil)
        self.type = type
        self.position = position
        self.animation = animation
        self.autohideIn = autohideIn
        self.dragToDismiss = dragToDismiss
        self.closeOnTap = closeOnTap
        self.closeOnTapOutside = closeOnTapOutside
        self.backgroundColor = backgroundColor
        self.dismissCallback = dismissCallback
        self.view = view
        self.isPresentedRef = ClassReference(self.$isPresented)
        self.itemRef = ClassReference(self.$item)
    }

    init(item: Binding<Item?>,
         type: PopupType,
         position: Position,
         animation: Animation,
         autohideIn: Double?,
         dragToDismiss: Bool,
         closeOnTap: Bool,
         closeOnTapOutside: Bool,
         backgroundColor: Color,
         dismissCallback: @escaping () -> (),
         view: @escaping (Item) -> PopupContent) {
        self._isPresented = .constant(false)
        self._item = item
        self.type = type
        self.position = position
        self.animation = animation
        self.autohideIn = autohideIn
        self.dragToDismiss = dragToDismiss
        self.closeOnTap = closeOnTap
        self.closeOnTapOutside = closeOnTapOutside
        self.backgroundColor = backgroundColor
        self.dismissCallback = dismissCallback
        self.viewWithItem = view
        self.isPresentedRef = ClassReference(self.$isPresented)
        self.itemRef = ClassReference(self.$item)
    }
    
    public enum PopupType {

        case `default`
        case toast
        case floater(verticalPadding: CGFloat = 10, useSafeAreaInset: Bool = true)

        func shouldBeCentered() -> Bool {
            switch self {
            case .`default`:
                return true
            default:
                return false
            }
        }
    }

    public enum Position {
        case top
        case bottom
    }

    private enum DragState {
        case inactive
        case dragging(translation: CGSize)

        var translation: CGSize {
            switch self {
            case .inactive:
                return .zero
            case .dragging(let translation):
                return translation
            }
        }

        var isDragging: Bool {
            switch self {
            case .inactive:
                return false
            case .dragging:
                return true
            }
        }
    }

    // MARK: - Public Properties

    /// Tells if the sheet should be presented or not
    @Binding var isPresented: Bool
    @Binding var item: Item?

    var sheetPresented: Bool {
        item != nil || isPresented
    }

    var type: PopupType
    var position: Position

    var animation: Animation

    /// If nil - never hides on its own
    var autohideIn: Double?

    /// Should close on tap - default is `true`
    var closeOnTap: Bool

    /// Should allow dismiss by dragging
    var dragToDismiss: Bool

    /// Should close on tap outside - default is `true`
    var closeOnTapOutside: Bool
    
    /// Background color for outside area - default is `Color.clear`
    var backgroundColor: Color

    /// is called on any close action
    var dismissCallback: () -> ()

    var view: (() -> PopupContent)?

    var viewWithItem: ((Item) -> PopupContent)?

    /// holder for autohiding dispatch work (to be able to cancel it when needed)
    var dispatchWorkHolder = DispatchWorkHolder()

    // MARK: - Private Properties
    
    /// Class reference for capturing a weak reference later in dispatch work holder.
    private var isPresentedRef: ClassReference<Binding<Bool>>?
    private var itemRef: ClassReference<Binding<Item?>>?

    /// The rect and safe area of the hosting controller
    @State private var presenterContentRect: CGRect = .zero
    @State private var presenterSafeArea: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

    /// The rect and safe area of popup content
    @State private var sheetContentRect: CGRect = .zero
    @State private var sheetSafeArea: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

    /// Drag to dismiss gesture state
    @GestureState private var dragState = DragState.inactive

    /// Last position for drag gesture
    @State private var lastDragPosition: CGFloat = 0

    /// Trigger popup showing/hiding animations and...
    @State private var shouldShowContent: Bool = false
    
    /// ... once hiding animation is finished remove popup from the memory using this flag
    @State private var showContent: Bool = false
    
    /// The offset when the popup is displayed
    private var displayedOffset: CGFloat {
        switch type {
        case .`default`:
            return -presenterContentRect.midY + screenHeight/2
        case .toast:
            if position == .bottom {
                return presenterContentRect.minY + presenterSafeArea.bottom + presenterContentRect.height - presenterContentRect.midY - sheetContentRect.height/2
            } else {
                return presenterContentRect.minY - presenterSafeArea.top - presenterContentRect.midY + sheetContentRect.height/2
            }
        case .floater(let verticalPadding, let useSafeAreaInset):
            if position == .bottom {
                return presenterContentRect.minY + presenterSafeArea.bottom + presenterContentRect.height - presenterContentRect.midY - sheetContentRect.height/2 - verticalPadding + (useSafeAreaInset ? -presenterSafeArea.bottom : 0)
            } else {
                return presenterContentRect.minY - presenterSafeArea.top - presenterContentRect.midY + sheetContentRect.height/2 + verticalPadding + (useSafeAreaInset ? presenterSafeArea.top : 0)
            }
        }
    }

    /// The offset when the popup is hidden
    private var hiddenOffset: CGFloat {
        if position == .top {
            if presenterContentRect.isEmpty {
                return -1000
            }
            return -presenterContentRect.midY - sheetContentRect.height/2 - 5
        } else {
            if presenterContentRect.isEmpty {
                return 1000
            }
            return screenHeight - presenterContentRect.midY + sheetContentRect.height/2 + 5
        }
    }

    /// The current offset, based on the **presented** property
    private var currentOffset: CGFloat {
        return shouldShowContent ? displayedOffset : hiddenOffset
    }
    
    /// The current background opacity, based on the **presented** property
    private var currentBackgroundOpacity: Double {
        return shouldShowContent ? 1.0 : 0.0
    }

    private var screenSize: CGSize {
        #if os(iOS) || os(tvOS)
        return UIScreen.main.bounds.size
        #elseif os(watchOS)
        return WKInterfaceDevice.current().screenBounds.size
        #else
        return NSScreen.main?.frame.size ?? .zero
        #endif
    }

    private var screenHeight: CGFloat {
        screenSize.height
    }

    // MARK: - Content Builders

    public func body(content: Content) -> some View {
        main(content: content)
            .onAppear {
                appearAction(sheetPresented: sheetPresented)
            }
            .valueChanged(value: isPresented) { isPresented in
                appearAction(sheetPresented: isPresented)
            }
            .valueChanged(value: item) { item in
                appearAction(sheetPresented: item != nil)
            }
    }

    private func main(content: Content) -> some View {
        ZStack {
            content
                .frameGetter($presenterContentRect, $presenterSafeArea)

            if showContent {
                popupBackground()
            }
        }
        .overlay(
            Group {
                if showContent {
                    sheet()
                }
            }
        )
    }

    private func popupBackground() -> some View {
        backgroundColor
            .applyIf(closeOnTapOutside) { view in
                view.contentShape(Rectangle())
            }
            .addTapIfNotTV(if: closeOnTapOutside) {
                dismiss()
            }
            .edgesIgnoringSafeArea(.all)
            .opacity(currentBackgroundOpacity)
    }

    /// This is the builder for the sheet content
    func sheet() -> some View {

        // if needed, dispatch autohide and cancel previous one
        if let autohideIn = autohideIn {
            dispatchWorkHolder.work?.cancel()
            
            // Weak reference to avoid the work item capturing the struct,
            // which would create a retain cycle with the work holder itself.
            
            let block = dismissCallback
            dispatchWorkHolder.work = DispatchWorkItem(block: { [weak isPresentedRef, weak itemRef] in
                isPresentedRef?.value.wrappedValue = false
                itemRef?.value.wrappedValue = nil
                block()
            })
            if sheetPresented, let work = dispatchWorkHolder.work {
                DispatchQueue.main.asyncAfter(deadline: .now() + autohideIn, execute: work)
            }
        }

        let sheet = ZStack {
            if let view = view {
                view()
                    .addTapIfNotTV(if: closeOnTap) {
                        dismiss()
                    }
                    .frameGetter($sheetContentRect, $sheetSafeArea)
                    .offset(y: currentOffset)
                    .onAnimationCompleted(for: currentOffset) {
                        showContent = shouldShowContent
                    }
                    .animation(animation, value: currentOffset)
            } else if let viewWithItem = viewWithItem, let item = item {
                viewWithItem(item)
                    .addTapIfNotTV(if: closeOnTap) {
                        dismiss()
                    }
                    .frameGetter($sheetContentRect, $sheetSafeArea)
                    .offset(y: currentOffset)
                    .onAnimationCompleted(for: currentOffset) {
                        showContent = shouldShowContent
                    }
                    .animation(animation, value: currentOffset)
            }
        }

        #if !os(tvOS)
        let drag = DragGesture()
            .updating($dragState) { drag, state, _ in
                state = .dragging(translation: drag.translation)
            }
            .onEnded(onDragEnded)

        return sheet
            .applyIf(dragToDismiss) {
                $0.offset(y: dragOffset())
                    .simultaneousGesture(drag)
            }
        #else
        return sheet
        #endif
    }

    #if !os(tvOS)
    func dragOffset() -> CGFloat {
        if (position == .bottom && dragState.translation.height > 0) ||
           (position == .top && dragState.translation.height < 0) {
            return dragState.translation.height
        }
        return lastDragPosition
    }

    private func onDragEnded(drag: DragGesture.Value) {
        let reference = sheetContentRect.height / 3
        if (position == .bottom && drag.translation.height > reference) ||
            (position == .top && drag.translation.height < -reference) {
            lastDragPosition = drag.translation.height
            withAnimation {
                lastDragPosition = 0
            }
            dismiss()
        }
    }
    #endif
    
    private func appearAction(sheetPresented: Bool) {
        if sheetPresented {
            showContent = true // immediately load popup body
            DispatchQueue.main.async {
                shouldShowContent = true // this will cause currentOffset change thus triggering the showing animation
            }
        } else {
            shouldShowContent = false // this will cause currentOffset change thus triggering the hiding animation
            // unload popup body after hiding animation is done (see sheet())
        }
    }
    
    private func dismiss() {
        dispatchWorkHolder.work?.cancel()
        isPresented = false
        item = nil
        dismissCallback()
    }
}

final class DispatchWorkHolder {
    var work: DispatchWorkItem?
}

final class ClassReference<T> {
    var value: T

    init(_ value: T) {
        self.value = value
    }
}


extension View {

    @ViewBuilder
    func valueChanged<T: Equatable>(value: T, onChange: @escaping (T) -> Void) -> some View {
        if #available(iOS 14.0, tvOS 14.0, macOS 11.0, watchOS 7.0, *) {
            self.onChange(of: value, perform: onChange)
        } else {
            self.onReceive(Just(value)) { value in
                onChange(value)
            }
        }
    }
}

struct FrameGetter: ViewModifier {

    @Binding var frame: CGRect
    @Binding var safeArea: EdgeInsets

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy -> AnyView in
                    let rect = proxy.frame(in: .global)
                    // This avoids an infinite layout loop
                    if rect.integral != self.frame.integral {
                        DispatchQueue.main.async {
                            self.safeArea = proxy.safeAreaInsets
                            self.frame = rect
                        }
                    }
                    return AnyView(EmptyView())
                }
            )
    }
}

extension View {
    public func frameGetter(_ frame: Binding<CGRect>, _ safeArea: Binding<EdgeInsets>) -> some View {
        modifier(FrameGetter(frame: frame, safeArea: safeArea))
    }
}

struct AnimationCompletionObserverModifier<Value>: AnimatableModifier where Value: VectorArithmetic {

    /// While animating, SwiftUI changes the old input value to the new target value using this property. This value is set to the old value until the animation completes.
    var animatableData: Value {
        didSet {
            notifyCompletionIfFinished()
        }
    }

    /// The target value for which we're observing. This value is directly set once the animation starts. During animation, `animatableData` will hold the oldValue and is only updated to the target value once the animation completes.
    private var targetValue: Value

    /// The completion callback which is called once the animation completes.
    private var completion: () -> Void

    init(observedValue: Value, completion: @escaping () -> Void) {
        self.completion = completion
        self.animatableData = observedValue
        targetValue = observedValue
    }

    /// Verifies whether the current animation is finished and calls the completion callback if true.
    private func notifyCompletionIfFinished() {
        guard animatableData == targetValue else { return }

        /// Dispatching is needed to take the next runloop for the completion callback.
        /// This prevents errors like "Modifying state during view update, this will cause undefined behavior."
        DispatchQueue.main.async {
            self.completion()
        }
    }

    func body(content: Content) -> some View {
        /// We're not really modifying the view so we can directly return the original input value.
        return content
    }
}

extension View {

    /// Calls the completion handler whenever an animation on the given value completes.
    /// - Parameters:
    ///   - value: The value to observe for animations.
    ///   - completion: The completion callback to call once the animation completes.
    /// - Returns: A modified `View` instance with the observer attached.
    func onAnimationCompleted<Value: VectorArithmetic>(for value: Value, completion: @escaping () -> Void) -> ModifiedContent<Self, AnimationCompletionObserverModifier<Value>> {
        return modifier(AnimationCompletionObserverModifier(observedValue: value, completion: completion))
    }
}

