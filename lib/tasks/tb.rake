require 'task_helpers/update_data'

namespace :tb do
  desc "TODO"
  task update_data: :environment do
    UpdateData.getcbsdata
  end

end
