"use strict"
angular.module("ng-slide-down", []).directive "ngSlideDown", ($timeout )->
  getTemplate = (tElement, tAttrs)->
    if tAttrs.lazyRender != undefined
      "<div><div ng-transclude ng-if='lazyRender'></div></div>"
    else
      "<div><div ng-transclude></div></div>"

  link = (scope, element, attrs, ctrl, transclude) ->
    duration = attrs.duration || 1
    timingFunction = attrs.timingFunction || "ease-in-out"
    elementScope = element.scope()
    emitOnClose = attrs.emitOnClose
    onClose = attrs.onClose
    lazyRender = attrs.lazyRender != undefined
    closePromise = null
    openPromise = null

    getHeight = (passedScope)->
      height = 0
      children = element.children()
      for c in children
        height += c.clientHeight
      "#{height}px"

    show = ()->
      $timeout.cancel(closePromise) if closePromise
      scope.lazyRender = true if lazyRender
      $timeout ->
        $timeout.cancel(openPromise) if openPromise
        element.css {
          overflowY: "hidden"
          transitionProperty: "height"
          transitionDuration: "#{duration}s"
          transitionTimingFunction: timingFunction
          height: getHeight()
        }
        openPromise = $timeout ()->
          element.css {
            overflowY: "visible"
            transition: "none",
            height: "auto"
          }
        , duration*1000


    hide = ()->
      $timeout.cancel(openPromise) if openPromise
      element.css {
        overflowY: "hidden"
        transitionProperty: "height"
        transitionDuration: "#{duration}s"
        transitionTimingFunction: timingFunction
        height: '0px'
      }
      if emitOnClose || onClose || lazyRender
        closePromise = $timeout ()->
          scope.$emit emitOnClose, {} if emitOnClose
          elementScope.$eval(onClose) if onClose
          scope.lazyRender = false if lazyRender
        , duration*1000

    scope.$watch 'expanded', (value, oldValue)->
      if value
        $timeout show
      else
        if value?
          element.css {
            height: getHeight()
          }
          element[0].clientHeight # Force reflow so the animation triggers reliably
        $timeout hide

  return {
    restrict: 'A'
    scope: {
      expanded: '=ngSlideDown'
    }
    transclude: true
    link: link
    template: (tElement, tAttrs)-> getTemplate(tElement, tAttrs)
  }
