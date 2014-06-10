require 'date'

module LogBook

  # FIXME:
  # ~/Library/Application Support/Alfred 2/Workflow Data/[bundle id]
  # に保存した方がいいらしい
  def self.filepath(date = DateTime.now)
    now = DateTime.now
    home = ENV['HOME']
    date = now.strftime('%Y-%m-%d')
    "#{home}/.logbook/#{date}.logbook"
  end

  def self.search(query = '')
    if query.empty?
      file = self.filepath

      return [] unless File.exists?(file)

      lines = File.open(file, 'r') { |f| f.read.lines }
      lines.map do |l|
        {
          title:    l.strip,
          file: file,
        }
      end
    else
      []
    end
  end

  def self.save(activity)
    file = self.filepath
    File.open(file, 'a+') do |f|
      now = DateTime.now
      time = now.strftime('%H:%M')
      f.puts("#{time} #{activity}")
    end
  end
end
