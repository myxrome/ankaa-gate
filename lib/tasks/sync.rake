namespace :sync do

  desc 'Copy common models and tests from Master'
  task :copy do
    statistic_source_path = '../ankaa-statistic'
    dest_path = '.'

    # Copy all models & tests
    %x{cp #{statistic_source_path}/app/models/*.rb #{dest_path}/app/models/}
    %x{cp #{statistic_source_path}/app/models/concerns/*.rb #{dest_path}/app/models/concerns/}

  end
end