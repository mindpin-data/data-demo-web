# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171017100532) do

  create_table "city_amounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "name"
    t.string  "amount"
    t.float   "long",     limit: 24
    t.float   "lat",      limit: 24
    t.boolean "in_china"
  end

  create_table "localities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "material"
    t.float  "amount",   limit: 24
    t.float  "long",     limit: 24
    t.float  "lat",      limit: 24
  end

  create_table "materials", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "color"
    t.string "locality_1"
    t.string "locality_2"
    t.string "locality_3"
    t.string "locality_4"
    t.string "locality_1_data"
    t.string "locality_2_data"
    t.string "locality_3_data"
    t.string "locality_4_data"
  end

  create_table "obor_countries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "code"
    t.float  "total",          limit: 24
    t.float  "percent_change", limit: 24
    t.string "now"
    t.string "history"
  end

  create_table "scourges", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "scourge"
    t.string "cdate"
    t.float  "lon",     limit: 24
    t.float  "lat",     limit: 24
  end

  create_table "total_amounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.float  "total",    limit: 24
    t.float  "export",   limit: 24
    t.string "now"
    t.string "forecast"
    t.string "history"
  end

end
