"use strict"
angular.module("ng-slider", []).directive "ngSlider", ($timeout )->
  getTemplate = (tElement, tAttrs)->
    if tAttrs.lazyRender != undefined
      "<div ng-if='lazyRender' ng-transclude></div>"
    else
      "<div ng-transclude></div>"

  link = (scope, element, attrs, ctrl, transclude) ->
    time = attrs.time || 1
    elementScope = element.scope()
    emitOnClose = attrs.emitOnClose
    onCloseEnd = attrs.onCloseEnd
    lazyRender = attrs.lazyRender != undefined
    closePromise = null
    element.css {
      overflow: "hidden"
      transitionProperty: "height"
      transitionDuration: "#{time}s"
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
      if emitOnClose || onCloseEnd || lazyRender
        closePromise = $timeout ()->
          scope.$emit emitOnClose, {} if emitOnClose
          elementScope.$eval(onCloseEnd) if onCloseEnd
          scope.lazyRender = false if lazyRender
        , time*1000

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
      expanded: '=ngSlider'
    }
    transclude: true
    link: link
    template: (tElement, tAttrs)-> getTemplate(tElement, tAttrs)
  }
