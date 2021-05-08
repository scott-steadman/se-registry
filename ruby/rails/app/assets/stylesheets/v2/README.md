# Stylesheets

## Overview
  These stylesheets use [BEMIT notation](https://csswizardry.com/2015/08/bemit-taking-the-bem-naming-convention-a-step-further/)
  with namespace prefixes.

### Design Goals
  I'm designing the site to be mobile first.
  So the pages render faster on mobile devices.
  I'm setting a min-width breakpoint at 40em (~640px).
  Everything within these breakpoint blocks will be used for larger viewports.

### Prefixes
  Prefixes are used to indicate a [namespace](https://csswizardry.com/2015/03/more-transparent-ui-code-with-namespaces/).

    c-        Component:  Represent specific parts of the UI
                          Examples: c-button, c-button--positive, c-date-picker
                          Safe to change.

    js-       JavaScript: Represents a class that javascript binds to.
                          Have javascript bind to an attribute instead.

    o-        Object:     Represents structural parts of the UI.
                          Examples: o-layout, o-layout__item, o-media
                          Used for layouts, wrappers, containers
                          Can underpin several, vastly different, components.
                          Risky to change.

    qa-       QA:         Represents something the QA team needs to find or bind to.
                          QA should change.

    s-        Scoped:     Used when you need to wrap content from an external source.
                          Examples: s-cms-content
                          Make sure you know what you're doing before using this.

    t-        Theme:      Represent cosmetic parts of the UI.
                          Examples: t-light, t-dark
                          Can be toggled on or off.
                          Usually added to body element.
                          ? to change

    u-        Utility:    Represents single UI responsibilty.
                          Examples: u-clearfix, u-text-center, u-1/3, u-2/3
                          Usually has !important
                          Never change.

    is-/has-  State:      Represents a optional/temporary UI state.

    _         Hack!       Represents a quick hack to get something to work.
                          Avoid or refactor ASAP.

### Suffixes:
    @breakpoint           Represents a media breakpoint
                          Example: o-media@md, u-1/4@lg, u-hidden@print
 
### BEM Notation:
   block__element--modifier

## File Organization
  The files are prefixed with their location in the
  [Inverted Triangle CSS (ITCSS)](https://www.xfive.co/blog/itcss-scalable-maintainable-css-architecture/)
  order.

### 10 - Settings
  Used with preprocessors and contain font, colors definitions, etc.

### 20 - Tools 
  Used mixins and functions. It’s important not to output any CSS in the first 2 layers.

### 30 - Generic
  Reset and/or normalize styles, box-sizing definition, etc.
  This is the first layer which generates actual CSS.

### 40 - Elements
  Styling for bare HTML elements (like H1, A, etc.).
  These come with default styling from the browser so we can redefine them here.

### 50 - Objects
  Class-based selectors which define undecorated design patterns, for example media object known from OOCSS

### 60 - Components
  Specific UI components.
  This is where the majority of our work takes place and our UI components are often composed of Objects and Components.

### 70 - Utilities
  Utilities and helper classes with ability to override anything which goes before in the hierarchy.
  eg. hide helper class
