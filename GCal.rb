# -*- coding: utf-8 -*-

require 'yaml'
require 'rubygems'
require 'google/api_client'


class GCal
  def initialize(name)
    oauth_yaml = YAML.load_file('.google-api.yaml')
    @client = Google::APIClient.new("application_name" => name)
    @client.authorization.client_id = oauth_yaml["client_id"]
    @client.authorization.client_secret = oauth_yaml["client_secret"]
    @client.authorization.scope = oauth_yaml["scope"]
    @client.authorization.refresh_token = oauth_yaml["refresh_token"]
    @client.authorization.access_token = oauth_yaml["access_token"]

    if @client.authorization.refresh_token && @client.authorization.expired?
      @client.authorization.fetch_access_token!
    end

    @service = @client.discovered_api('calendar', 'v3')

  end

  def create_events_from_time_entrys(entrys, google_calender_id)
    entrys.each do |entry|
      puts entry["description"]
      if entry["stop"] == nil
        endtime = change_date_format_for_time(Time.now.to_s)
      else
        endtime = change_date_format_for_time_entry(entry["stop"])
      end
      event = {
        'summary' => entry["description"],
        'start' => {
          'dateTime' => change_date_format_for_time_entry(entry["start"])
        },
        'end' => {
          'dateTime' => endtime
        },
      }
      result = @client.execute(:api_method => @service.events.insert,
                               :parameters => {'calendarId' => google_calender_id},
                               :body => JSON.dump(event),
                               :headers => {'Content-Type' => 'application/json'})
    end
  end

  private
  def change_date_format_for_time_entry(date)
    /(\d\d\d\d-\d\d-\d\d\T\d\d:\d\d:\d\d)([+-]\d\d:\d\d)/  =~ date
    return $1 + ".000" + $2
  end

  def change_date_format_for_time(time)
    /(\d\d\d\d-\d\d-\d\d)\s(\d\d:\d\d:\d\d)\s([+-]\d\d)(\d\d)/ =~ time
    return $1 + "T" + $2 + ".000" + $3 + ":" + $4
  end
  
end
