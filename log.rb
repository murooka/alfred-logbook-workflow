require "rexml/document"
require 'date'
load 'logbook.rb'

def to_xml(items)
  doc = REXML::Element.new('items')
  items.each do |item|
    default = {
      subtitle: '',
      icon:     'icon.png',
      valid:    'yes',
      type:     'default',
    }

    item = default.merge(item)
    item[:title]        ||= item[:title]
    item[:arg]          ||= item[:title]
    item[:autocomplete] ||= item[:title]


    elem = doc.add_element('item')
    elem.add_attributes({
      'arg'          => item[:arg],
      'valid'        => item[:valid],
      'autocomplete' => item[:autocomplete],
    })
    elem.add_attribute('uid', item[:uid]) unless item[:uid].nil?
    elem.add_attribute('type', 'file') if item[:type] == 'file'

    e = elem.add_element('title')
    e.text = item[:title]

    e = elem.add_element('subtitle')
    e.text = item[:subtitle]

    icon = elem.add_element('icon')
    icon.text = item[:icon]
  end

  doc.to_s
end

q = ARGV[0].strip
now = DateTime.now
time = now.strftime("%H:%M")

fbs = []
fbs << {
  title:    "#{time} #{q}",
  subtitle: "Create new log",
  valid:    'yes',
  arg:      q,
}
fbs += LogBook.search.reverse.map do |log|
  {
    title:        log[:title],
    subtitle:     log[:file],
    valid:        'yes',
    arg:          log[:file],
    autocomplete: '',
    type:         'file',
  }
end

puts(to_xml(fbs))
