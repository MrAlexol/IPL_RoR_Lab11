class AddUniqueConstraintToSequences < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
      DROP INDEX IF EXISTS index_sequences_on_values;
      ALTER TABLE "sequences"
      DROP COLUMN "values";
      ALTER TABLE "sequences"
      ADD "values" varchar(255) NOT NULL UNIQUE;
    SQL
    add_index :sequences, :values, unique: true
  end

  def down
    execute <<-SQL
      DROP INDEX IF EXISTS values_idx;
      ALTER TABLE "sequences"
      DROP COLUMN "values";
      ALTER TABLE "sequences"
      ADD "values" varchar(255);
      CREATE INDEX index_sequences_on_values ON "sequences" ("values");
    SQL
  end
end
