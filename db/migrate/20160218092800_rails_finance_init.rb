class CreateSubjects < ActiveRecord::Migration[5.0]
  def change

    create_table :subjects do |t|
      t.string :name
      t.string :request_method
      t.string :request_path
      t.json :path_params
      t.json :request_params
      t.json :request_headers
      t.string :request_type
      t.json :request_body

      t.string :response_status
      t.json :response_headers
      t.string :response_type
      t.text :response_body

      t.string :note

      t.timestamps
    end

    enable_extension 'hstore' unless extension_enabled?('hstore')
    create_table :maps do |t|
      t.string :name
      t.hstore :mappings
      t.timestamps
    end

  end
end
