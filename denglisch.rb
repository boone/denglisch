# Denglisch Mobile App in Sinatra
require 'sinatra'
require 'active_record'
#require 'yaml'

set :show_exceptions, true if development?

DB_CONFIG = YAML.load_file("#{settings.root}/config/database.yml")[settings.environment.to_s]

ActiveRecord::Base.establish_connection(:adapter => DB_CONFIG['adapter'], :database => DB_CONFIG['database'],
                                        :username => DB_CONFIG['username'], :password => DB_CONFIG['password'],
                                        :host => DB_CONFIG['host'], :encoding => DB_CONFIG['encoding'],
                                        :reconnect => DB_CONFIG['reconnect'], :pool => DB_CONFIG['pool'])

class Word < ActiveRecord::Base; end

get '/' do
  # index
  erb :index
end

post '/search' do
  @query = params[:query]

  if @query
    @query.gsub!(/[\|;{}]/, '') # filter out special characters from query: | ; { }
    @query.strip!

    unless @query.blank?
      german_exact_words = Word.all(:conditions => ['german REGEXP ?', "[[:<:]]#{@query}[[:>:]]"], :limit => 10)
      german_exact_words_ids = german_exact_words.collect(&:id)
      german_embedded_words = Word.all(:conditions => ['german LIKE ? AND id NOT IN (?)', "%#{@query}%", german_exact_words_ids], :limit => 10)

      english_exact_words = Word.all(:conditions => ['english REGEXP ?', "[[:<:]]#{@query}[[:>:]]"], :limit => 10)
      english_exact_words_ids = english_exact_words.collect(&:id)
      english_embedded_words = Word.all(:conditions => ['english LIKE ? AND id NOT IN (?)', "%#{@query}%", english_exact_words_ids], :limit => 10)

      @exact_words = (german_exact_words + english_exact_words).uniq
      @embedded_words = (german_embedded_words + english_embedded_words).uniq
    end
  end
  erb :search
end

helpers do
  # based on Rails 3 code
  def highlight(text, phrases, *args)
    highlighter = '<strong class="highlight">\1</strong>'

    # text = sanitize(text) unless options[:sanitize] == false
    if text.blank? || phrases.blank?
      text
    else
      match = Array(phrases).map { |p| Regexp.escape(p) }.join('|')
      text.gsub(/(#{match})(?!(?:[^<]*?)(?:["'])[^<>]*>)/i, highlighter)
    end
  end
end
