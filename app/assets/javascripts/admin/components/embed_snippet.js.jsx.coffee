window.Snippets ||= {}

Snippets['Embed'] = React.createClass
  name_for: (field)->
    "article[snippets_attributes][#{this.props.i}][#{field}]"

  render: ->
    `<div className='snippet embed-snippet'>
      <input type='hidden' name={this.name_for('_id')} value={this.props.id}/>
      <input type='hidden' name={this.name_for('_type')} value='Snippets::Embed'/>
      <textarea name={this.name_for('body')} className='form-control' rows={4} defaultValue={this.props.body}/>
    </div>`