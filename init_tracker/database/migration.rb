module InitTracker
  module Database
    class Migration < ActiveRecord::Migration[5.2]
      def up
        if !table_exists?(:inits)
          create_table :inits do |table|
            table.string :server_id
            table.string :channel_id
            table.string :started_by_user
            table.text :characters
            table.integer :round
            table.string :message_id
            table.integer :lock_version
            table.timestamps
            table.index :server_id
            table.index :channel_id
          end
          add_index :lists, [:server_id, :channel_id]
        end

        if !table_exists?(:servers)
          create_table :servers do |table|
            table.string :server_id
            table.string :server_name
            table.string :added_by_user
            table.datetime :removed_on
            table.string :removed_by_user
            table.text :settings
            table.index :server_id
            table.index :removed_on
            table.timestamps
          end
        end

        if !column_exists?(:inits, :round)
          add_column :inits, :round, :integer, default: 0
        end

        if !column_exists?(:inits, :message_id)
          add_column :inits, :message_id, :string, default: nil
        end

        if !column_exists?(:servers, :settings)
          add_column :servers, :settings, :text, default: nil
        end
        
      end

      def down
        drop_table :inits
        drop_table :servers
      end
    end
  end
end
