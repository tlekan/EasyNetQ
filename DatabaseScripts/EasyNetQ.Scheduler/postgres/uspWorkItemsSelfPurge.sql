CREATE OR REPLACE FUNCTION "uspWorkItemsSelfPurge"(p_rows smallint, p_purgedate timestamp without time zone)
  RETURNS void AS
$BODY$
BEGIN

WHILE ((SELECT count(*) FROM workItemStatus WHERE purgeDate <= p_purgeDate) > 0) LOOP
	  DELETE 
	  FROM workItems wi
	  WHERE wi.workItemId in
	(
	select workItemId 
	from workItemStatus ws
	where ws.purgeDate <= p_purgeDate
		limit p_rows
	);
END LOOP;
	
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION "uspWorkItemsSelfPurge"(smallint, timestamp without time zone)
  OWNER TO postgres;
