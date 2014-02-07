import indexer;
//get dataset to index
l_chin := RECoRD, LOCALE('CN')
UNICODE R,
UNICODE CREATED_AT,
UNICODE STATUSID,
UNICODE TXT,
UNICODE SOURCE,
UNICODE FAVORITED,
UNICODE TRUNCATED,
UNICODE IN_REPLY_TO_STATUS_ID,
UNICODE IN_REPLY_TO_USER_ID,
UNICODE IN_REPLY_TO_SCREEN_NAME,
UNICODE MID,
unicode BMIDDLE_PIC,
unicode ORIGINAL_PIC,
unicode THUMBNAIL_PIC,
unicode REPOSTS_COUNT,
unicode COMMENTS_COUNT,
unicode ANNOTATIONS,
unicode GEO,
unicode USERID,
unicode RETWEETEDSTATUSID,
unicode STATUS_TYPEID,
unicode CTISTATUS,
unicode tTYPE,
unicode PARENTID,
unicode ATUSERID,
unicode IS_RETWEETED,
unicode CHANNEL,
unicode IS_IMPORTANT,
unicode MOOD,
unicode KEYWORDS,
unicode DEAL_AGENT,
unicode INTERACTION_ID,
unicode DEAL_AT,
unicode IS_TREND,
unicode TREND,
unicode CAMPAIGN,
unicode CAMPAIGN_STATUSID,
unicode SUB_TYPE,
unicode PARENT_COMMENT_ID,
unicode TAGS,
unicode IS_HOT,
unicode IS_CRISIS,
unicode PLATFORM,
unicode URL_CRC,
unicode IS_TASK,
unicode SESSIONID,
unicode split_text
END;

fname := '~drea::chinsplit';
ds:=DATASET(fname,l_chin,CSV(Heading(0),separator('~'),UNICODE));

//add a source id & record id field to the file. The source will by the
//hash64 of fname and the record_id is a counter . the field names added 
//will be "source_id" and "record_id"
indexer.Transforms.AddRecSource(ds,fname,source_id,record_id,dsrec);

//create inverted entities from whatever fields in the dataset you wish
indexer.Transforms.MakeEntity(dsrec,'Created Time',created_at,created_at,source_id,record_id,2,1,'Created Time',dscreated_at)
indexer.Transforms.MakeEntity(dsrec,'Status ID',statusid,statusid,source_id,record_id,3,1,'Status ID',dsstatusid)
indexer.Transforms.MakeEntity(dsrec,'Text',split_text,txt,source_id,record_id,4,1,'Text',dstxt)
indexer.Transforms.MakeEntity(dsrec,'In Reply To user ID',in_reply_to_user_id,in_reply_to_user_id,source_id,record_id,9,1,'In Reply To user ID',dsin_reply_to_user_id)
indexer.Transforms.MakeEntity(dsrec,'In Reply To Screen Name',in_reply_to_screen_name,in_reply_to_screen_name,source_id,record_id,10,1,'In Reply To Screen Name',dsin_reply_to_screen_name)
indexer.Transforms.MakeEntity(dsrec,'Geo',geo,geo,source_id,record_id,18,1,'Geo',dsgeo)
indexer.Transforms.MakeEntity(dsrec,'Userid',userid,userid,source_id,record_id,19,1,'Userid',dsuserid)
indexer.Transforms.MakeEntity(dsrec,'AT User ID',atuserid,atuserid,source_id,record_id,25,1,'AT User ID',dsatuserid)
indexer.Transforms.MakeEntity(dsrec,'Channel',channel,channel,source_id,record_id,27,1,'Channel',dschannel)
indexer.Transforms.MakeEntity(dsrec,'Important',is_important,is_important,source_id,record_id,28,1,'Important',dsis_important)
indexer.Transforms.MakeEntity(dsrec,'Mood',mood,mood,source_id,record_id,29,1,'Mood',dsmood)
indexer.Transforms.MakeEntity(dsrec,'Keywords',keywords,keywords,source_id,record_id,30,1,'Keywords',dskeywords)
indexer.Transforms.MakeEntity(dsrec,'Deal Agent',deal_agent,deal_agent,source_id,record_id,31,1,'Deal Agent',dsdeal_agent)
indexer.Transforms.MakeEntity(dsrec,'Deal At',deal_at,deal_at,source_id,record_id,33,1,'Deal At',dsdeal_at)
indexer.Transforms.MakeEntity(dsrec,'url',url_crc,url_crc,source_id,record_id,44,1,'url',dsurl_crc)

//output(dsrec);
dsentities:=dstxt+dscreated_at; //etc, etc ;

indexname:='testdata';

sequential(
//generate data file for this set of entities to be added to superfile
//		~indexer::data::testdata_bmp created, accessible via dynamic superfile
//		  indexer.Indexes.BitmapDataSuperFile (it includes anything like '~indexer::data::*_bmp' added after the last bitmap index was compiled)
indexer.buildindexes.removebuildadd(dsentities,indexname)

//from the above BitmapDataSuperFile, generate indexes and add them to superfiles:
//		~indexer::idx::bitmapsk-testdata created, added to SK indexer::idx::bitmapsk <-used for bitmap search
//		~indexer::idx::compiledrecndx-testdata created, added to SK indexer::idx::compiledrecndx <-used for bitmap search
//		~indexer::idx::compiledcolwordposndx-testdata created, added to SK indexer::idx::compiledcolwordposndx  <- used for phrase searching
//		~indexer::data::bitmap-testdata, added to SF ~indexer::data::bitmap  <- used for retrieving addtl data for recs once bmp search is done

,indexer.buildindexes.RollupIndexes(indexname)
//indexer.buildindexes.RollupRecentIndexes(indexname); //create indexes from any data added with removebuildadd after the last rollupindexes was called

//generate the word count index and substring indexes for wildcard searches (* & ?). 
//this can be done less frequently, especially across a corpus with limited vocabulary
,indexer.buildindexes.IRMetaDataBatchTasks
);
