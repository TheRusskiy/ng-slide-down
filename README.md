Ng Slide Down
=================

AngularJS directive for vertical slide down animation ([JS Fiddle](http://jsfiddle.net/therusskiy/JR3C7/4/)).
## Installation
Just add this module as a dependency: 

<code>angular.module("myApp", ['ng-slide-down'])</code>

You can download this module from bower using

<code>bower install ng-slide-down</code>
## Usage
In order to use a directive add attribute <code>ng-slide-down</code> to an element you want to hide. Pass some variable to it as a value and it's going to serve as a trigger to expand/hide the element: <code>lazy-render="someVariable"</code>.
## Features
#### Lazy rendering
Has option to prevent HTML generation of contents unless expanded (due to performance considerations). Optimal for a big number of widgets (production tested).
All you need to do is to add <code>lazy-render</code> attribute to an element with a directive.
#### Automatic height adjustment
Directive watches for a height of it's content and readjusts it's size automatically - no extra work required. 
## Options
#### ng-slide-down (required)
Main attribute, required for directive to work, passed variable defines whether element should slide down or slide up

<code>&lt;div ng-slide-down=&quot;slideDown&quot;&gt;</code>
#### duration
Time in seconds for animation to complete (default is 1 second).

<code>&lt;div ng-slide-down=&quot;slideDown&quot; duration=&quot;1.5&quot;&gt;</code>

#### timing-function
Easing function (`transition-timing-function`) to use in the animation (default is ease-in-out).

<code>&lt;div ng-slide-down=&quot;slideDown&quot; timing-function=&quot;linear&quot;&gt;</code>
#### lazy-render
Add this attribute to prevent rendering when content is hidden. Doesn't require value.

<code>&lt;div ng-slide-down=&quot;slideDown&quot; lazy-render&gt;</code>
#### on-close
Expression evaluated when slider is finished closing

<code>&lt;div ng-slide-down=&quot;slideDown&quot; on-close=&quot;someVariable = true&quot;&gt;</code>
#### emit-on-close
Message emitted when slider is finished closing

<code>&lt;div ng-slide-down=&quot;slideDown&quot; emit-on-close=&quot;widget_closed&quot;&gt;</code>

Then you can subscribe to it in an outer scope:

<pre><code>$scope.on('widget_closed', function() { /* do stuff */ });</code></pre>
 
## Usage example
Full version can be found on [JS Fiddle](http://jsfiddle.net/therusskiy/JR3C7/4/)
 
<pre>
<code>
&lt;div ng-click=&quot;widgetExpanded = !widgetExpanded&quot;&gt;
  Click to slide in/out
&lt;/div&gt;
&lt;div ng-slide-down=&quot;widgetExpanded&quot; lazy-render duration=&quot;1&quot;&gt;
  Some awesome content here
&lt;/div&gt;
</code>
</pre>

### Words of caution
Lazy render may not work for older angular versions due to a
  [bug (fixed on 20.05.2014)](https://github.com/angular/angular.js/pull/7499). Make sure to update your angular.
  
If your content has padding or margins make sure to wrap it into div without them.

<pre>
<code>
&lt;div ng-slide-down=&quot;slideDown&quot;&gt;
    &lt;div&gt; &lt;!-- wrapper --&gt;  
    ... content with padding ...
    &lt;/div&gt;  
&lt;/div&gt;
</code>
</pre>

## Building yourself
Source code is written in CoffeeScript, in order to build it just run <code>grunt</code> command in your CLI and it will take care of compiling to JS and minifying.

## Contributing
Oh darling... You are always welcome!
## License

This code is released under the [MIT License](http://www.opensource.org/licenses/MIT).
