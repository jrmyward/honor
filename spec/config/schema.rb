ActiveRecord::Schema.define :version => 0 do
  create_table "employees", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
  end

  create_table "points", :force => true do |t|
    t.integer  "user_id"
    t.integer  "value"
    t.string   "category"
    t.text     "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end
  add_index "points", ["user_id"], :name => "index_points_on_user_id"

  create_table "scorecards", :force => true do |t|
    t.integer  "user_id"
    t.integer  "daily"
    t.integer  "weekly"
    t.integer  "monthly"
    t.integer  "yearly"
    t.integer  "lifetime"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end
  add_index "scorecards", ["user_id"], :name => "index_scorecards_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
  end

end