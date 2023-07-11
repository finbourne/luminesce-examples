/*

Description:

In the queries below, we search GLEIF for company details.
https://search.gleif.org/#/search/

For more details on enabling the GLEIF provider in your domain, please contact 
your FINBOURNE representative.


=========================
    Search using an LEI
========================

*/

@lei_values=values
('lei','9695000O3YMLZSDQ9Z45'),
('lei','851WYGNLUQLFZBSYGB56');

@lei_request=select column1 as FilterField, column2 as FilterValueMatch from @lei_values;

select *
from   Gleif.LegalEntity.MatchFilter
where   request=@lei_request;

/*

=========================================
    Search using an entity category 
========================================

*/


@entity_values=values
('entity.category','RESIDENT_GOVERNMENT_ENTITY');

@entity_request=select column1 as FilterField, column2 as FilterValueMatch from @entity_values;

select *
from   Gleif.LegalEntity.MatchFilter
where   request=@entity_request limit 5;

/*

=====================================================
    Get child, direct parent and ultimate parent
=====================================================

Commerzbank Finance B.V. (724500KGJLP14RSC0819)
--> has direct parent COMMERZBANK FINANCE LIMITED (213800BWHAS44J2C1B28)
--> ultimate parent-->COMMERZBANK Aktiengesellschaft (851WYGNLUQLFZBSYGB56)

*/


@lei_request2=select 'lei' as FilterField, '724500KGJLP14RSC0819' as FilterValueMatch;

@leis=select * from Gleif.LegalEntity.MatchFilter where request=@lei_request2;

--Request data on parent and ultimate parent
@linkRequest=
select 'lei' as FilterField, DirectParentLei as FilterValueMatch
from @leis where DirectParentLei is not null
union
select 'lei' as FilterField, UltimateParentLei as FilterValueMatch
from @leis where UltimateParentLei is not null;

@parentLeis=select * from Gleif.LegalEntity.MatchFilter where request=@linkRequest;

--Output child, direct parent and ultimate parent
select * from @leis union
select * from @parentLeis;
