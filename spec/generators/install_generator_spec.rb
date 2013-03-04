require 'spec_helper'

# Generators are not automatically loaded by Rails
require 'generators/honor/install/install_generator'

describe Honor::Generators::InstallGenerator do
  # Tell the generator where to put its output (what it thinks of as Rails.root)
  destination File.expand_path("../../../../../tmp", __FILE__)

  before do
    prepare_destination
    Rails::Generators.options[:rails][:orm] = :active_record
  end
  describe 'no arguments' do
    before { run_generator  }

    describe 'db/migrate/create_honor_points.rb' do
      subject { file('db/migrate/create_honor_points.rb') }
      it { should be_a_migration }
    end

    describe 'db/migrate/create_honor_scorecards.rb' do
      subject { file('db/migrate/create_honor_scorecards.rb') }
      it { should be_a_migration }
    end
  end
end
