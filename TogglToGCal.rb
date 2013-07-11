# -*- coding: utf-8 -*-
require 'yaml'
require 'json'
require './TogglAPI'
require './GCal'

setting = YAML.load_file('setting.yml')

toggl = TogglAPI.new(setting['toggl_api_token'])
now = Time.now
entrys = toggl.get_time_entries_started_in_a_specific_time_range(setting["before_date"], now)

gcal = GCal.new('TogglToGCal')
gcal.create_events_from_time_entrys(entrys, setting["google_calender_id"])

#次回のタイムエントリの取得範囲の書き換え
setting["before_date"] = now
open("setting.yml","w") do |f|
YAML.dump(setting,f)
end
