
Time::DATE_FORMATS[:datetime] = "%H:%M %d-%b-%Y"  # date.to_s(:datetime)  ---->  15:30 24-Dec-2009
Time::DATE_FORMATS[:date] = "%d/%b/%Y"            # date.to_s(:date)      ---->  24-Dec-2009
Time::DATE_FORMATS[:time] = "%H:%M"               # date.to_s(:time)      ---->  15:30
Time::DATE_FORMATS[:google] = "%Y-%m-%d %H:%M:%S" # date.to_s(:google)  ---->  2009-12-24 15:30:27


# In rails, output of a date field uses Date::DATE_FORMATS[:default]
Date::DATE_FORMATS[:default] = Time::DATE_FORMATS[:date]

# To display the current date and time in all the formats in your current environment:
Time::DATE_FORMATS.keys.each{|k| puts [k,Date.today.to_s(k)].join(':- ')}
Time::DATE_FORMATS.keys.each{|k| puts [k,Time.now.to_s(k)].join(':- ')}