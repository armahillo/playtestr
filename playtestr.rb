#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require_relative './lib/playtestr'

# Use the default OptionParser for CLI
require 'optparse'
options = {cards: "import/cards.yml", format: "pdf", css: nil, output: nil}
option_parser = OptionParser.new do |opts|
  # Switches
  opts.on("-v", "--verbose") do # Provide STDOUT output when cards are added
    options[:verbose] = true
  end
  
  # Flags
  opts.on("-c", "--cards CARDS",
          "YML Sourcefile for your card definitions") do |cards|
    unless File.exist?(cards)
      raise ArgumentError, "Could not find card source file: #{cards}"
    end
    options[:cards] = cards
  end

  opts.on('-f', '--format FORMAT') do |format|
    case format
    when 'jpg'
      options[:format] = 'jpg'
    end
  end

  opts.on("-o FILE", "--output FILE") do |file|
    unless File.writable?(File.dirname(file))
      raise ArgumentError, "Cannot write to #{File.dirname(file)}"
    end
    if File.exist?(file) && !File.writable?(file)
      raise ArgumentError, "#{file} exists, but is not writable"
    end
    case File.extname(file)
    when ".html"
      options[:format] = "html"
    when ".pdf"
      options[:format] = "pdf"
    else
      raise ArgumentError, "Output file must be an html or pdf file"
    end
    options[:output] = file
  end

  opts.on("-s CSS", "--stylesheet CSS") do |css|
    unless File.exist?(css)
      raise ArgumentError, "Could not find stylesheet: #{css}"
    end
    unless options[:format] == "html"
      raise ArgumentError, "Cannot use a stylesheet unless you're outputting to HTML"
    end
    options[:css] = css
  end
end

begin
  option_parser.parse!
rescue ArgumentError => e
  puts "Error: #{e}"
  exit(-1)
end

ENV["verbose"] = "true" if options[:verbose]

deck = Playtestr::Deck.new(options[:cards])
case options[:format]
  when "pdf"
    destination = options[:output].nil? ? "export/rendered_#{Time.now.to_i}.pdf" : options[:output]
    template = Playtestr::PdfTemplate.new(destination)
    
  when "html"
    destination = options[:output].nil? ? "export/rendered_#{Time.now.to_i}.html" : options[:output]
    css = options[:css].nil? ? "assets/stylesheets/default.css" : options[:css]
    template = Playtestr::HtmlTemplate.new(destination, css)

  when 'jpg'
    destination_dir = options[:output].nil? ? "export/#{Time.now.to_i}" : options[:output]
    assets_dir = options[:assets].nil? ? "./import" : options[:assets]
    Dir.mkdir(destination_dir)
    template = Playtestr::JpgTemplate.new(destination_dir, assets_dir)

  else
    puts "USAGE: playtestr.rb format=[pdf|html|jpg]"
end

deck.map(&template.method(:<<))
template.render
