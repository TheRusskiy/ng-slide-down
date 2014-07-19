"use strict"
angular.module("ng-slide-down", []).directive "ngSlideDown", ($timeout )->
  getTemplate = (tElement, tAttrs)->
    if tAttrs.lazyRender != undefined
      "<div ng-if='lazyRender' ng-transclude></div>"
    else
      "<div ng-transclude></div>"

  link = (scope, element, attrs, ctrl, transclude) ->
    duration = attrs.duration || 1
    elementScope = element.scope()
    emitOnClose = attrs.emitOnClose
    onClose = attrs.onClose
    lazyRender = attrs.lazyRender != undefined
    closePromise = null
    element.css {
      overflow: "hidden"
      transitionProperty: "height"
      transitionDuration: "#{duration}s"
      transitionTimingFunction: "ease-in-out"
    }

    getHeight = (passedScope)->
      height = 0
      children = element.children()
      for c in children
        height += c.clientHeight
      "#{height}px"

    show = ()->
      $timeout.cancel(closePromise) if closePromise
      scope.lazyRender = true if lazyRender
      element.css('height', getHeight())


    hide = ()->
      element.css('height', '0px')
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
        $timeout hide

    scope.$watch getHeight, (value, oldValue)->
      if scope.expanded && value!=oldValue
        $timeout show

  return {
    restrict: 'A'
    scope: {
      expanded: '=ngSlideDown'
    }
    transclude: true
    link: link
    template: (tElement, tAttrs)-> getTemplate(tElement, tAttrs)
  }
