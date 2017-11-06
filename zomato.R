library(jsonlite)
library(data.table)


### get all the zomato establishments and events in Metro Manila
# establishments
url <- 'curl -X GET --header "Accept: application/json" --header "user-key: d915d1daef56cb92c09b857aee2d8038" "https://developers.zomato.com/api/v2.1/search?entity_id=63&entity_type=city"'
ext <- ' > Moonlight/zomato/search.json'
system(paste0(url,ext), intern = TRUE)
out <- as.data.frame(fromJSON('Moonlight/zomato/search.json'))$restaurant
out_ <- cbind(res_id = out$id, 
              res_name = out$name, 
              res_url = out$url,
              out$location, 
              switch_to_order_menu = out$switch_to_order_menu,
              cuisines = out$cuisines, 
              average_cost_for_two = out$average_cost_for_two, 
              price_range = out$price_range, 
              currency = out$currency,
              thumb = out$thumb, 
              out$user_rating, 
              photos_url = out$photos_url, 
              menu_url = out$menu_url,
              featured_image = out$featured_image,
              has_online_delivery = out$has_online_delivery, 
              is_delivering_now = out$is_delivering_now, 
              deeplink = out$deeplink, 
              has_table_booking = out$has_table_booking,
              events_url = out$events_url)
# events
event <- NULL
for (i in 1:20){
  if (length(out$zomato_events[[i]]) != 0){
    eve <- cbind(res_id = out$id[i], res_name = out$name[i], 
                 (out$zomato_events[[i]]$event)[1:9],
                 (out$zomato_events[[i]]$event)[12:22])
    event <- rbind(event, eve)
  }else{}
  
}

#### Looping GET 
out_ <- NULL
event <- NULL
for(i in seq(1,1000,20)){
  
  print(paste('Start processing', i))
  url <- 'curl -X GET --header "Accept: application/json" --header "user-key: 25104ceb900e55009037fa4f2a77d36e" "https://developers.zomato.com/api/v2.1/search?entity_id=63&entity_type=city'
  increm <- paste0('&start=', i, '"')
  ext <- ' > Moonlight/zomato/search.json'
  system(print(paste0(url,increm,ext)), intern = TRUE)
  
  temp <- as.data.frame(fromJSON('Moonlight/zomato/search.json'))$restaurant
  print(paste('number of row of temp',nrow(temp)))
  temp_ <- cbind(res_id = temp$id, 
                 res_name = temp$name, 
                 res_url = temp$url,
                 temp$location, 
                 switch_to_order_menu = temp$switch_to_order_menu,
                 cuisines = temp$cuisines, 
                 average_cost_for_two = temp$average_cost_for_two, 
                 price_range = temp$price_range, 
                 currency = temp$currency,
                 thumb = temp$thumb, 
                 temp$user_rating, 
                 photos_url = temp$photos_url, 
                 menu_url = temp$menu_url,
                 featured_image = temp$featured_image,
                 has_online_delivery = temp$has_online_delivery, 
                 is_delivering_now = temp$is_delivering_now, 
                 deeplink = temp$deeplink, 
                 has_table_booking = temp$has_table_booking,
                 events_url = temp$events_url)
  print(paste('number of row of temp_',nrow(temp_)))
  
  out_ <- rbind(out_, temp_)
  print(paste('number of row of out_',nrow(out_)))
  
  
  for (j in 1:20){
    if (length(temp$zomato_events[[j]]) != 0){
      eve <- as.data.frame(cbind(res_id = temp$id[j], res_name = temp$name[j], 
                                 (temp$zomato_events[[j]]$event)[1:9],
                                 (temp$zomato_events[[j]]$event)[12:22]))
      event <- rbind(event, eve)
    }else{}
  }
  print(paste('number of row of events:',nrow(event)))
  
  print(paste('Done iteration:', i+19))
}