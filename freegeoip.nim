# Nim module for determining location from IP addresses.
# Uses freegeoip: https://github.com/fiorix/freegeoip

# Written by Adam Chesak.
# Released under the MIT open source license.


import httpclient
import json
import strutils


type
    GeoIpInfo* = tuple[ip : string, countryCode : string, countryName : string, regionCode : string, regionName : string,
                       city : string, zipCode : string, timeZone : string, latitude : string, longitude : string,
                       metroCode : string]


# Internal API link. Other instances of freegeoip can be used as well, as long as this
# link is changed to the new server.
const API_LINK = "http://www.freegeoip.net/json/"


proc getIpInfo*(ip : string): GeoIpInfo = 
    ## Gets info for the specified IP or hostname.
    
    var response : string = getContent(API_LINK & ip)
    var data : JsonNode = parseJson(response)
    
    var info : GeoIpInfo
    info.ip = data["ip"].str
    info.countryCode = data["country_code"].str
    info.countryName = data["country_name"].str
    info.regionCode = data["region_code"].str
    info.regionName = data["region_name"].str
    info.city = data["city"].str
    info.zipCode = data["zip_code"].str
    info.timeZone = data["time_zone"].str
    info.latitude = formatBiggestFloat(data["latitude"].getFNum, format = ffDecimal)
    info.longitude = formatBiggestFloat(data["longitude"].getFNum)
    info.metroCode = intToStr(int(data["metro_code"].getNum))
    
    return info


proc getMyIpInfo*(): GeoIpInfo = 
    ## Gets info for the current IP.
    
    return getIpInfo("")


when isMainModule:
    var currentInfo : GeoIpInfo = getMyIpInfo()
    echo("IP INFO FOR " & currentInfo.ip & "\n")
    echo("Country code\t" & currentInfo.countryCode)
    echo("Country name\t" & currentInfo.countryName)
    echo("Region code\t" & currentInfo.regionCode)
    echo("Region name\t" & currentInfo.regionName)
    echo("City\t\t" & currentInfo.city)
    echo("Zip code\t" & currentInfo.zipCode)
    echo("Time zone\t" & currentInfo.timeZone)
    echo("Latitude\t" & currentInfo.latitude)
    echo("Longitude\t" & currentInfo.longitude)
    echo("Metro code\t" & currentInfo.metroCode)
