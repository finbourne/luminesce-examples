-- =============================================================
-- Description:
-- In this query, we setup a view to get instrument info based on 
-- Issuer
-- =============================================================


@issuerView = use Sys.Admin.SetupView
--provider=Views.Luminesce_examples.Instruments_By_Issuer
--parameters
IssuerIdFilter,Text,2138002658CPO9NBH955,false
----


-- Get all instruments for issuer

@@scope = select 'luminesce-examples';
@@issuerId = select #PARAMETERVALUE(IssuerIdFilter);

@issuers =
select *
from Lusid.LegalEntity
where IssuerId = @@issuerId
;

--find issuer relationships and link instrument details

@relLookUp =
select
@@scope as EntityScope,
'LegalEntity' as EntityType,
'IssuerId' as EntityCode,
IssuerId as EntityValue
from @issuers
;

select 
i.LusidInstrumentId,
i.DisplayName as InstrumentName,
iss.DisplayName as IssuerName,
iss.IssuerId,
rd.DisplayName,
i.[Type],
capType.Value as CapitalType,
payPri.Value as PaybackPriority
from Lusid.Relationship r
left join Lusid.Relationship.Definition rd
    on r.RelationshipScope = rd.Scope
    and r.RelationshipCode = rd.Code
left join Lusid.Instrument i
    on r.RelatedEntityValue = i.ClientInternal
        left join Lusid.Instrument.Property capType
            on i.LusidInstrumentId = capType.InstrumentId
            and capType.InstrumentIdType = 'LusidInstrumentId'
            and capType.InstrumentScope = @@scope
            and capType.PropertyScope = @@scope
            and capType.PropertyCode = 'CapitalType'
        left join Lusid.Instrument.Property payPri
            on i.LusidInstrumentId = payPri.InstrumentId
            and payPri.InstrumentIdType = 'LusidInstrumentId'
            and payPri.InstrumentScope = @@scope
            and payPri.PropertyScope = @@scope
            and payPri.PropertyCode = 'PaybackPriority'
left join @issuers iss
    on r.EntityValue = iss.IssuerId
where r.toLookUp = @relLookUp
order by payPri.Value asc
;


enduse;

select * from @issuerView;
