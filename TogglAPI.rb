# -*- coding: utf-8 -*-
require 'json'
class TogglAPI
  def initialize(token)
    @curlhead = "curl -u " + token + ":api_token"
    @basehttp = "https://www.toggl.com/api/v8/"
    @type = " -H \"Content-type: application/json\" "
    @get = " -X GET "
    @put = " -X PUT "
    @post = " -X POST "
    @delete = " -X DELETE "
  end
  
  #Authenticate and get user data
  def auth_with_token
    result = use_cmd(@curlhead + @get + @basehttp + "me")
    save_file("auth_result.txt", result)
    JSON.parse(result)
  end

  #Clients
  def create_a_client(name, wid, notes = nil)
    h = Hash::new
    h["name"] = name
    h["wid"] = wid
    if notes != nil
      h["notes"] = notes
    end
    client = generate_hash("client", h)
    result = use_cmd(@curlhead + @type + create_send_data(client) + @post + @basehttp + "clients")
    save_file("create_a_client_log.txt", result)
    JSON.parse(result)
  end

  def update_a_client(name, notes = nil, client_id)
    h = Hash::new
    h["name"] = name
    if notes != nil
      h["notes"] = notes
    end
    client = generate_hash("client", h)
    result = use_cmd(@curlhead + @type + create_send_data(client) + @put + @basehttp + "clients/" + client_id.to_s)
    save_file("update_a_client_log.txt", result)
    JSON.parse(result)
  end

  def delete_a_client(client_id)
    result = use_cmd(@curlhead + @delete + @basehttp + "clients/" + client_id.to_s)
    save_file("update_a_client_log.txt", result)
  end

  def get_clients_visible_to_user
    result = use_cmd(@curlhead + @get + @basehttp + "clients")
    save_file("clients_list.txt", result)
    JSON.parse(result)
  end

  def get_client_projects(client_id)
    result = use_cmd(@curlhead + @get + @basehttp + "clients/" + client_id.to_s + "/projects")
    fname = client_id.to_s + "_project_list.txt"
    save_file(fname, result)
    JSON.parse(result)
  end

  #Projects
  def create_a_project
    
  end 

  def get_project_data
    
  end

  def update_project_data
    
  end

  def get_project_users
    
  end

  #Project users
  def create_a_project_user
    
  end

  def update_a_project_user
    
  end

  def delete_a_project_user
    
  end 

  def add_multiple_users_to_a_project
    
  end

  def update_multiple_project_users
    
  end

  def delete_multiple_project_users
    
  end

  #Tags
  def create_a_tag
    
  end

  def update_a_tag
    
  end

  def delete_a_tag
    
  end

  #Tasks
  #pro workspace only
  def create_a_task(name, pid)
    task = {"task"=> {"name"=> name, "pid"=> pid}}
    result = use_cmd(@curlhead + @type + create_send_data(task) + @post + @basehttp + "tasks")
    save_file("create_a_task_log.txt", result)
    JSON.parse(result)
  end

  def get_task_details
    
  end

  def update_a_task
    
  end

  def delete_a_task
    
  end

  def update_multiple_tasks
    
  end

  def delete_multiple_tasks
    
  end

  #Time entries
  def create_a_time_entry(des = "", wid = nil, pid = nil, start, duration)
    h = Hash::new
    h["description"] = des
    if wid != nil
      h["wid"] = wid
    end
    if pid != nil
      h["pid"] = pid
    end
    h["start"] = start
    h["duration"] = duration
    timeentry = generate_hash("time_entry", h)
    result = use_cmd(@curlhead + @type + create_send_data(timeentry) + @post + @basehttp + "time_entries")
    save_file("time_entry_create_log.txt", result)
    JSON.parse(result)
  end

  def start_a_time_entry(des = "", wid = nil, pid = nil)
    h = Hash::new
    h["description"] = des
    if wid != nil
      h["wid"] = wid
    end
    if pid != nil
      h["pid"] = pid
    end
    timeentry = generate_hash("time_entry", h)
    result = use_cmd(@curlhead + @type + create_send_data(timeentry) + @post + @basehttp + "time_entries/start")
    save_file("time_entry_start_log.txt", result)
    JSON.parse(result)    
  end

  def stop_a_time_entry(id)
    result = use_cmd(@curlhead + @type + @put + @basehttp + "time_entries/" + id.to_s + "/stop")
    save_file("time_entry_stop_log.txt", result)
    JSON.parse(result)
  end

  def get_time_entry_details(id)
    result = use_cmd(@curlhead + @get + @basehttp + "time_entries/" + id.to_s)
    save_file("time_entry_details.txt", result)
    JSON.parse(result)    
  end

  def update_time_entry(des = nil, wid = nil, pid = nil, start = nil, stop = nil, duration = nil, time_entry_id)
        h = Hash::new
    if des != nil
      h["description"] = des
    end
    if wid != nil
      h["wid"] = wid
    end
    if pid != nil
      h["pid"] = pid
    end
    if start != nil
      h["start"] = start
    end
    if stop != nil
      h["stop"] = stop
    end
    if duration != nil
      h["duration"] = duration
    end
    timeentry = generate_hash("time_entry", h)
    result = use_cmd(@curlhead + @type + create_send_data(timeentry) + @put + @basehttp + "time_entries/" + time_entry_id.to_s)
    save_file("update_time_entry_log.txt", result)
    JSON.parse(result)
  end

  def delete_a_time_entry(id)
    result = use_cmd(@curlhead + @delete + @basehttp + "time_entries/" + id.to_s)
    save_file("delete_time_entry_result.txt", result)
    result
  end

  def get_time_entries_started_in_a_specific_time_range(sdate,edate)
    sdate = change_date(sdate.to_s)
    edate = change_date(edate.to_s)
    result = use_cmd(@curlhead + @get + @basehttp + 'time_entries?start_date=' + sdate + "&end_date=" + edate)
    puts @curlhead + @get + @basehttp + '\"time_entries?start_date=' + sdate + "&end_date=" + edate + '\"'
    fname = "time_entrys" + sdate + "-" + edate + ".txt"
    save_file(fname, result)
    JSON.parse(result)    
  end

  #Users
  def get_current_user_data_and_time_entries
    
  end

  def sign_up_new_user
    
  end

  #Workspaces
  def get_workspaces
    result = use_cmd(@curlhead + @get + @basehttp + "workspaces")
    save_file("workspaces.txt", result)
    JSON.parse(result)
  end

  def get_workspace_users(wid)

  end

  def get_workspace_clients(wid)
    fname = wid.to_s + "_clients.txt"
    result = use_cmd(@curlhead + @get + @basehttp + "workspaces/" + wid.to_s + "/clients")   
    save_file(fname, result)
    JSON.parse(result)
  end
  
  def get_workspace_projects(wid)
    fname = wid.to_s + "_projects.txt"
    result = use_cmd(@curlhead + @get + @basehttp + "workspaces/" + wid.to_s + "/projects")   
    save_file(fname, result)
    JSON.parse(result)
  end

  def get_workspace_tasks(wid)
    fname = wid.to_s + "_tasks.txt"
    result = use_cmd(@curlhead + @get + @basehttp + "workspaces/" + wid.to_s + "/tasks")   
    save_file(fname, result)
    JSON.parse(result)
  end

  #Workspace users
  def update_workspace_user
    
  end

  def delete_workspace_user
    
  end

  private
  def use_cmd(str)
    result = ""
    IO.popen(str, "r+") do |io|
      while line = io.gets
        result << line
      end
    end
    result
  end
  
  def save_file(name, content)
    f = open(name, "w")
    f.write(content)
  end

  def generate_hash(type, dhash)
    h = Hash.new{|h,k| h[k]=Hash.new(&h.default_proc)}
    dhash.each{|key, value|
      h[type][key] = value
    } 
    h
  end

  def create_send_data(data)
    "-d '" + JSON.generate(data) + "'"
  end

  def change_date(date)
    /(\d\d\d\d-\d\d-\d\d)\s(\d\d):(\d\d):(\d\d)\s\+(\d\d)(\d\d)/ =~ date
    $1 + "T" + $2 + "%3A" + $3 + "%3A" + $4 + "%2B" + $5 + "%3A" + $6
  end
end


