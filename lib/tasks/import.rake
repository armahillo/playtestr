namespace :import do
  desc "[foo/*.csv] Import a directory of CSVs and convert them to YMLs in /import/"
  task :csv, [:filelist] do |t,args|
    files = FileList[args[:filelist]]
    files.each do |file|
      imported_filename = Playtestr::Import.from_csv(file).to_yml!
      puts "Imported #{File.basename(file)} => import/#{imported_filename}"
    end
  end
end
