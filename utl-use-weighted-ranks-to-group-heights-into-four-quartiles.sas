
Use weighted ranks to group heights into 4 quartiles

see github
https://tinyurl.com/yby92wd7
https://github.com/rogerjdeangelis/utl-use-weighted-ranks-to-group-heights-into-four-quartiles

SAS Forum
https://tinyurl.com/y8y2rcoy
https://communities.sas.com/t5/SAS-Procedures/how-can-I-create-a-variable-that-indicates-the-percentile-that/m-p/498090

I am not comfortable using weight with ranking
but this seems to work.
INPUT
=====

 SD1.HAVE total obs=19

  NAME       WGT    HEIGHT

  Alfred      14     112.5
  Alice       13      84.0
  Barbara     13      98.0
  Carol       14     102.5
  Henry       14     102.5
  James       12      83.0
  Jane        12      84.5
  Janet       15     112.5


EXAMPLE OUTPUT
--------------

 WORK.WANT total obs=19

                                          QUARTILE_
  NAME       WGT    HEIGHT    WTD_RANK      HEIGHT

  Alfred      14     69.0       230.5         3
  Alice       13     56.5        30.0         0
  Barbara     13     65.3       172.0         2
  Carol       14     62.8       118.5         2
  Henry       14     63.5       132.5         2
  James       12     57.3        42.5         0
  Jane        12     59.8        77.5         1
  Janet       15     62.5        97.5         1


PROCESS
=======


%utl_submit_r64('
  library(haven);
  library(Hmisc);
  library(SASxport);
  have<-read_sas("d:/sd1/have.sas7bdat");
  rnk<-as.data.frame(wtd.rank(have$HEIGHT, weights=have$WGT));
  write.xport(rnk,file="d:/xpt/rxpt.xpt");
');

libname xpt xport "d:/xpt/rxpt.xpt";

data wnt1st;
  merge sashelp.class(keep = name age height rename=age=wgt ) xpt.rnk;
run;quit;

proc rank data=wnt1st groups=4 out=want;
      var wtd_rank;
      ranks quartile_height;
run;

OUTPUT
======

see above

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;

libname sd1 "d:/sd1";

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have(keep = name wgt height);
  set sashelp.class(rename=age=wgt);
run;quit;



