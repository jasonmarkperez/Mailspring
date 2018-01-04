RetinaImg = require('./retina-img').default
{React, ReactDOM, PropTypes, Utils} = require 'mailspring-exports'
classnames = require 'classnames'

class ButtonDropdown extends React.Component
  @displayName: "ButtonDropdown"
  @propTypes:
    primaryItem: PropTypes.element
    primaryClick: PropTypes.func
    bordered: PropTypes.bool
    menu: PropTypes.element
    style: PropTypes.object
    closeOnMenuClick: PropTypes.bool
    attachment: PropTypes.string,

  @defaultProps:
    style: {}
    attachment: 'left'

  constructor: (@props) ->
    @state = open: false

  render: =>
    classes = classnames
      'button-dropdown': true
      'open open-up': @state.open is 'up'
      'open open-down': @state.open is 'down'
      'bordered': @props.bordered isnt false

    menu = if @state.open then @props.menu else false

    if @props.primaryClick
      <div ref="button" onBlur={@_onBlur} tabIndex={-1} className={"#{classes} #{@props.className ? ''}"} style={@props.style}>
        <div className="primary-item"
             title={@props.primaryTitle ? ""}
             onClick={@props.primaryClick}>
          {@props.primaryItem}
        </div>
        <div className="secondary-picker" onClick={@toggleDropdown}>
          <RetinaImg name={"icon-thread-disclosure.png"} mode={RetinaImg.Mode.ContentIsMask}/>
        </div>
        <div className="secondary-items" onMouseDown={@_onMenuClick}>
          {menu}
        </div>
      </div>
    else
      <div ref="button" onBlur={@_onBlur} tabIndex={-1} className={"#{classes} #{@props.className ? ''}"} style={@props.style}>
        <div className="only-item"
             title={@props.primaryTitle ? ""}
             onClick={@toggleDropdown}>
          {@props.primaryItem}
          <RetinaImg name={"icon-thread-disclosure.png"} style={marginLeft:12} mode={RetinaImg.Mode.ContentIsMask}/>
        </div>
        <div className={"secondary-items #{@props.attachment}"} onMouseDown={@_onMenuClick}>
          {menu}
        </div>
      </div>

  toggleDropdown: =>
    if @state.open isnt false
      @setState(open: false)
    else
      buttonBottom = ReactDOM.findDOMNode(@).getBoundingClientRect().bottom
      if buttonBottom + 200 > window.innerHeight
        @setState(open: 'up')
      else
        @setState(open: 'down')

  _onMenuClick: (event) =>
    if @props.closeOnMenuClick
      @setState open: false

  _onBlur: (event) =>
    target = event.nativeEvent.relatedTarget
    if target? and ReactDOM.findDOMNode(@refs.button).contains(target)
      return
    @setState(open: false)

module.exports = ButtonDropdown
