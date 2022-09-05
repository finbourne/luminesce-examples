-- =====================================================
-- Description:
-- 1. In this query, we create event notifications from
-- the reconciliation results
-- =====================================================

-- define strings for a pass and fail reconciliation

@@failed_event =

select 'HoldingReconFailed';

@@passed_event =

select 'HoldingReconPassed';

-- Count the number of breaks from thr reconciliation
-- We use an absolute count to assess if there are
-- any breaks or not

@recon_result =

select sum(abs(Units_Diff)) as [Breaks]
from Test.Example.HoldingsRecon
where portfolio = 'UkEquityActive';

-- If there are breaks, we generate a failed event
-- If there are no breaks, we generate a passed event

@event =

select iif(Breaks = 0, @@passed_event, @@failed_event) as [EventToGenerate]
from @recon_result;

-- Generate the event in LUSID

@@event_to_generate =

select EventToGenerate
from @event;

@event_details =

select 'Manual' as [EventType], @@event_to_generate as [Message], ('Holdings recon: ' || @@event_to_generate
      ) as [Subject], date () as [EventTime];

select *
from Notification.Event.Writer
where ToWrite = @event_details;