* Encoding: UTF-8.
DEFINE external_source(flow=!tokens(1)
                   /year=!tokens(1)
                   /quarter=!tokens(1)
                   /outlier_sd_limit=!tokens(1)
                   )

SET DECIMAL DOT.

GET DATA  
  /TYPE=TXT
  /FILE=!quote(!concat("data/",!flow," - ",!year,"_External_source_Q",!quarter,".csv"))
  /DELCASE=LINE
  /DELIMITERS=","
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /VARIABLES=
    flow A1
    year F4
    month F2
    ref A14
    ItemID A8
    comno A9
    country A2
    unit A8
    weight F17
    quantity F17
    value F17
    valUSD F17
    itemno F17
    exporterNUIT A9.
EXECUTE.

FORMATS weight quantity (F12.0) value valusd (F17.0).

    
* --- Set measurement levels ---.

* Nominal variables.
VARIABLE LEVEL 
    flow year month ref ItemID comno country unit itemno exporterNUIT (NOMINAL).

* Scale variables.
VARIABLE LEVEL 
    weight quantity value valUSD (SCALE).
    
EXECUTE.

COMPUTE quarter = month / 3.
COMPUTE quarter = TRUNC(quarter) + (quarter > TRUNC(quarter)).
EXECUTE.


* Compute price per transaction.
COMPUTE price = value / weight.
EXECUTE.

* Choose actual year.
ADD FILES FILE=!quote(!concat('Data/External_source_',!flow,'.sav'))
         /FILE=*
         .
EXECUTE.

* Check to see if the index for the quarter is already made, if so we keep the latest version.
SORT CASES BY flow comno year month.
MATCH FILES FILE=*
           /LAST=last_idx
           /BY flow comno year month
           .
FREQUENCIES last_idx.

SELECT IF (last_idx = 1).
EXECUTE.
DELETE VARIABLES last_idx.

TEMPORARY.
SELECT IF (year >= !year-1).

CTABLES
  /VLABELS VARIABLES=comno year month price DISPLAY=LABEL
  /TABLE comno BY year > month > price [MEAN F8.2]
  /SLABELS VISIBLE=NO
  /CATEGORIES VARIABLES=comno year month ORDER=A KEY=VALUE EMPTY=EXCLUDE
  /CRITERIA CILEVEL=95
  /TITLES
    TITLE='External source - Unit values'.

    
SAVE outfile=!quote(!concat('Data/External_source_',!flow,'.sav')).

!ENDDEFINE.

