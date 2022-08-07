SET datestyle = GERMAN, DMY;

with expense as 
/*To calculate how much is being spent */
(
  select 
    user_id, 
    sum(
      bronze_price -(
        (bronze_price * 0.023)+ 0.1
      )
    ) as bronze_cost, 
    sum(
      silver_price -(
        (silver_price * 0.023)+ 0.1
      )
    ) as silver_cost, 
    sum(
      gold_price -(
        (gold_price * 0.023)+ 0.1
      )
    ) as gold_cost 
  from 
    (
      select 
        user_id, 
        case when lower(chosen_package)= 'bronze' then 20 else 0 end as bronze_price, 
        case when lower(chosen_package)= 'silver' then 50 else 0 end as silver_price, 
        case when lower(chosen_package)= 'gold' then 70 else 0 end as gold_price 
      from 
        user_
    ) a 
  group by 
    user_id
), 
sales as 
/*To get the total sales made*/
(
  select 
    user_id, 
    sum(
      case when lower(chosen_package)= 'bronze' then 20 else NULL end
    ) as bronze_price, 
    sum(
      case when lower(chosen_package)= 'silver' then 50 else NULL end
    ) as silver_price, 
    sum(
      case when lower(chosen_package)= 'gold' then 70 else NULL end
    ) as gold_price 
  from 
    user_ 
  group by 
    user_id
) 
select 
  round(
	  sum(
    (s.bronze_price - e.bronze_cost)/ s.bronze_price
  ),2) as bronze_profit_margin, 
  round(
	  sum(
    (s.silver_price - e.silver_cost)/ s.silver_price
  ),2) as silver_profit_margin, 
  
  round(
	  sum(
    (s.gold_price - e.gold_cost)/ s.gold_price
  ),2) as gold_profit_margin 
from 
  expense e 
  join sales s on s.user_id = e.user_id

/*with this code, the package with the highest profit margin is silver*/