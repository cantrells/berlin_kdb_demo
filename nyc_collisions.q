
/ function to load in data from the csv file
/ example:
/ param1 - list of characters, defining the types of the columns being loaded in from the file
/ param2 - file path as a symbol
/ collisionData:loadCollisionData["DNSSFF****IIIIIIII*****SSSSSS";`:raw/NYPD_Motor_Vehicle_Collisions.csv]
loadData:{[types;file]
  / load csv file in with given types
  raw:(types;enlist csv)0:file;
  / rename the columns to have console-friendly names
  newCols:`$ssr[;" ";"_"]each string lower cols raw;
  / apply the new column names to the table and output the data
  newCols xcol raw
  };

/ exact same function as above, but written in k
/ collisionData:loadDataK["DNSSFF****IIIIIIII*****SSSSSS";`:raw/NYPD_Motor_Vehicle_Collisions.csv]
k)loadDataK:{[types;file]
	 {c:`${.q.lower ?[x=" ";"_";x]}'$:!:d:+:x;+:c!.:d}(types;(),",")0:file};


/ function to save an in memory table to disk
/ slightly modified version of the in-built function .Q.dpft
/ http://code.kx.com/q/ref/dotq/#qdpft-save-table
/ same paramters except n is table name as a symbol, and t is the table data
k)saveToDisk:{[d;p;f;n;t]i:<t f;if[~&/.Q.qm'r:+.Q.enx[$;d]t;'`unmappable];{[d;t;i;u;x]@[d;x;:;u t[x]i]}[d:.Q.par[d;p;n];r;i;]'[(::;`p#)f=!r;!r];@[d;`.d;:;f,r@&~f=r:!r];n};

/ function to group a table by it's date column and save it to a hdb in a date partitioned format
saveAll:{[dir;field;name;tab] saveToDisk[dir;;field;name;].'flip{(key[x];value x)}(delete date from tab) group tab`date};
/ more efficient way of storing this data would be with larger partitions, i.e. grouping by year instead of date
saveAllYearDB:{[dir;field;name;tab] tab:update year:`year$date from tab;saveToDisk[dir;;field;name;].'flip{(key[x];value x)}(delete year from tab) group tab`year};


/ function to pivot the data on month
/ http://code.kx.com/q/cookbook/pivoting-tables/
/ parameter t - table of data
pivotOnMonth:{[t]
 P:asc exec distinct month from t;
 pvt:exec P#(month!accidents) by time:time from t;
 pvt};

monthMap:`jan`feb`mar`apr`may`jun`jul`aug`sep`oct`nov`dec;



