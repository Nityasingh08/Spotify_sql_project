--Retrive the track names that have been streamed on spotify more than youtube
 select*from
 (
  select
      track,
      coalesce(sum(case when most_playedon ='Youtube'then stream end),0) as streamed_on_youtube,
      coalesce(sum(case when most_playedon ='Spotify'then stream end),0) as streamed_on_spotify
   from spotify
   group by 1
 ) as T1
 where streamed_on_spotify > streamed_on_youtube
 and
 streamed_on_youtube <> 0


select*from spotify;

-------------ADVANCE----------------
--find top 3 most viewed tracks for each artist using windows function
with ranking_artist
as
(select
   artist,
   track,
   sum(views) as total_sum,
   dense_rank() over(partition by artist order by sum(views)desc) as rank
from spotify
group by 1,2
order by 1,3 desc)
select * from ranking_artist
where 
    rank < 4

--write a query to find track where liveness score is above average
select  
   artist,
   track,
   liveness
from spotify
where liveness > (select avg (liveness) from spotify)

--use a WITH clause to cal the diffference between
--the highest and lowest energy values for tracks in each album
with cte
as
(select 
   album,
   Max(energy) as max_energy,
   Min(energy) as min_energy
from spotify   
 group by 1)
 select 
    album,
	max_energy - min_energy
	from cte
	order by 2 desc

 