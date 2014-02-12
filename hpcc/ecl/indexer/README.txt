NOTE: this indexer is built to run on HPCC open-source platform version 4.2.0 or higher.


To build indexes, do the following:
	spray sampledatautf8.txt to the cluster as a UTF-8 csv file, ~ delimited, with one header line, with filename ~indexer::data::examplechinese

	bring up bwr_sampleindexgeneration.ecl in a builder window and run it

	verify that data and indexes are created in the ~indexer directory

To make the indexes available for searching:
	deploy wsSearch, wsSearchSimple, wsEntityTypes and wsLookupWord to roxie