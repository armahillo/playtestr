namespace :export do
  desc "[pdf|html] Render all YML files in import/ folder into the appropriate format in export/"
  task :all, [:format] do |t, args|
    format = args[:format] || 'pdf'

    FileList['./import/*.yml'].each do |file|
      deck = Playtestr::Deck.new(file)
      destination = 'export/' + File.basename(file).rpartition('.').first
      
      template = case format
      when 'pdf'
        destination += ".pdf"
        Playtestr::PdfTemplate.new(destination)
      when 'html'
        destination += ".html"
        css = "assets/stylesheets/default.css"
        Playtestr::HtmlTemplate.new(destination, css)
      end
      deck.map(&template.method(:<<))
      template.render
    end
  end
end