# data can be found at http://ftp.tu-chemnitz.de/pub/Local/urz/ding/de-en/
# the file "de-en.txt" should go in the data directory
desc 'import data from data/de-en.txt'
task :import_data => :environment do
  counter = 0
  created = 0

  Word.delete_all # clean out the existing rows
  
  filepath = File.join(File.dirname(__FILE__) + '/../../data/de-en.txt')

  File.readlines(filepath).each do |line|
    # comment lines begin with #, ignore those
    if line.strip[0,1] != '#'
      row = line.split('::')
      if row.size == 2
        Word.create(:german => row[0].strip, :english => row[1].strip)
        created += 1
      else
        puts "Bad row at #{counter}: #{row.inspect}"
      end
    end
    counter += 1
    puts counter if counter % 1000 == 0
  end
  
  puts "Processed #{counter} lines, added #{created} words."
end
