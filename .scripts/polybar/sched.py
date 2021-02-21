#!/usr/bin/python
import sys
import datetime
import pandas as pd

mindayidx = 3
dayidxs = {'Mon':3,'Tue':4,'Wed':5,'Thu':6,'Fri':7,'Sat':8,'Sun':9}
idxday =  {3:'Mon',4:'Tue',5:'Wed',6:'Thu',7:'Fri',8:'Sat',9:'Sun'}
schedule = pd.read_csv('~/.config/polybar/schedules/schedule.cln',delimiter=':')

def scrapedate():
    now = datetime.datetime.now()
    day =  now.strftime("%a")
    hour = int(now.hour)
    if now.minute < 30:
        minn = 00
    else:
        minn = 30
    return day,hour,minn
def cyclemin(minn,modtime):
    if (modtime % 2) != 0:
        if minn == 30:
            return 0
        elif minn == 0:
            return 30
    else:
        return minn

def cyclehour(hour,modtime,minn):
    dayincrement = 0
    if modtime > 0:
        if modtime%2 == 0:
            hour += modtime/2
        else:
            if minn == 30:
                hour += (modtime-1)/2 + 1
            else:
                hour += (modtime-1)/2
    elif modtime < 0:
        modtime = abs(modtime)
        if modtime%2 == 0:
            hour -= modtime/2
        else:
            if minn == 30:
                hour -= (modtime-1)/2 + 1
            else:
                hour -= (modtime-1)/2
    #handle day change
    if hour >= 24:
        hour = hour - 24
        dayincrement = 1
    elif hour < 0:
        hour = 24 + hour
        dayincrement = -1
    return int(hour),dayincrement

def cycleday(cday,dayincrement):
    if dayincrement == 0:
        return cday
    else:
        newidx = dayidxs[cday] + dayincrement
        if newidx > 9:
            newidx = 3
        elif newidx < 3:
            newidx = 9
        return idxday[newidx]

def getactivity(day,hour,minn):
    activity = schedule[(schedule['hour'] == hour) & (schedule['min'] == minn)][day].values[0]
    if activity == None:
        return 'None'
    else:
        return activity

def formathour(tfhour,minn):
    am='AM'
    if tfhour > 12:
        tfhour -= 12
        am='PM'
    elif tfhour == 12:
        am='PM'
    elif tfhour == 00:
        tfhour = 12
    if minn == 0:
        minn = '00'
    return '{}:{}{}'.format(tfhour,minn,am)

def main(modtime):
    day,hour,minn = scrapedate()
    gmin = cyclemin(minn,modtime)
    ghour,incr = cyclehour(hour,modtime,minn)
    gday = cycleday(day,incr)
    activity = getactivity(gday,ghour,gmin)
    ftime = formathour(ghour,gmin)
    return '{} {}'.format(ftime,activity)


if __name__ == '__main__':
    modtimes = [0]
    if len(sys.argv) == 2:
        modtimes = [int(sys.argv[1])]
    elif len(sys.argv) == 3:
        modtimes = list(range(int(sys.argv[1]),int(sys.argv[2])+1))
    activities = [main(x) for x in modtimes]
    print('|'.join(activities))

