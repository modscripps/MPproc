function CTDsensorinfo=CTDsensorinfo_MP(sn)
%function CTDsensor=CTDsensor_MP(sn)

CTDsensorinfo.sn=sn;

switch sn
    case '1348',
        CTDsensorinfo.type='FSI EMCTD';
        CTDsensorinfo.owner='Toole';
    case '1352',
        CTDsensorinfo.type='FSI EMCTD';
        CTDsensorinfo.owner='Toole';
    case '1378',
        CTDsensorinfo.type='FSI EMCTD';
        CTDsensorinfo.owner='Toole';
    case '1353',
        CTDsensorinfo.type='FSI EMCTD';
        CTDsensorinfo.owner='Toole';
    case '1339',
        CTDsensorinfo.type='FSI EMCTD';
        CTDsensorinfo.owner='Toole';
    case '1360',
        CTDsensorinfo.type='FSI EMCTD';
        CTDsensorinfo.owner='IARC';
    case '1359',
        CTDsensorinfo.type='FSI EMCTD';
        CTDsensorinfo.owner='IARC';
    case '1371',
        CTDsensorinfo.type='FSI EMCTD';
        CTDsensorinfo.owner='Toole';
    case '1372',
        CTDsensorinfo.type='FSI EMCTD';
        CTDsensorinfo.owner='Toole';
    case '1373',
        CTDsensorinfo.type='FSI EMCTD';
        CTDsensorinfo.owner='Toole';        
    case '1361',
        CTDsensorinfo.type='FSI EMCTD';
        CTDsensorinfo.owner='Alford';
        %Here we fill in the history of the sensor
        rec=1;
        therecord.date={'6/03'};
        therecord.what={'purchased'};
        therecord.host={'101'};
        therecord.comments={''};
        CTDsensorinfo.records{rec}=therecord;
        rec=rec+1;

        therecord.data={'5/04'};
        therecord.what={'calibrated'};
        therecord.host={'101'};
        cal.info='1361_may04.doc';
        therecord.cal=cal;
        CTDsensorinfo.records{rec}=therecord;
        rec=rec+1;


        %PS03
        therecord.date={'9/03'};
        therecord.what={'deployed PS03'};
        therecord.host={'101'};
        therecord.comments={''};
        CTDsensorinfo.records{rec}=therecord;
        rec=rec+1;

        therecord.date={'12/03'};
        therecord.what={'recovered PS03'};
        therecord.host={'101'};
        therecord.comments={''};
        CTDsensorinfo.records{rec}=therecord;
        rec=rec+1;

        %AEG04
        therecord.date={'8/04'};
        therecord.what={'deployed AEG04'};
        therecord.host={'101'};
        therecord.comments={''};
        CTDsensorinfo.records{rec}=therecord;
        rec=rec+1;

        therecord.date={'11/04'};
        therecord.what={'recovered AEG04'};
        therecord.host={'101'};
        therecord.comments={''};
        CTDsensorinfo.records{rec}=therecord;
        rec=rec+1;

    case '1368',
        CTDsensorinfo.type='FSI EMCTD';
        CTDsensorinfo.owner='Alford';
        %Here we fill in the history of the sensor
        rec=1;
        therecord.date={'6/03'};
        therecord.what={'purchased'};
        therecord.host={'102'};
        therecord.comments={''};

        CTDsensorinfo.records{rec}=therecord;
        rec=rec+1;
        
        %AEG04
        therecord.date={'8/04'};
        therecord.what={'deployed AEG04'};
        therecord.host={'102'};
        therecord.comments={''};

        CTDsensorinfo.records{rec}=therecord;
        rec=rec+1;

        therecord.date={'11/04'};
        therecord.what={'recovered AEG04'};
        therecord.host={'102'};
        therecord.comments={''};

        CTDsensorinfo.records{rec}=therecord;
        rec=rec+1;
    case '1369',
        CTDsensorinfo.type='FSI EMCTD';
        CTDsensorinfo.owner='Alford';
        %Here we fill in the history of the sensor
        rec=1;
        therecord.date={'6/03'};
        therecord.what={'purchased'};
        therecord.host={'103'};
        therecord.comments={''};

        CTDsensorinfo.records{rec}=therecord;
        rec=rec+1;
        
        %AEG04
        therecord.date={'8/04'};
        therecord.what={'deployed AEG04'};
        therecord.host={'103'};
        therecord.comments={''};

        CTDsensorinfo.records{rec}=therecord;
        rec=rec+1;

        therecord.date={'11/04'};
        therecord.what={'recovered AEG04'};
        therecord.host={'103'};
        therecord.comments={''};

        CTDsensorinfo.records{rec}=therecord;
        rec=rec+1;

    case '0357',
        CTDsensorinfo.type='SBE CTD 43F';
        CTDsensorinfo.owner='Toole';
        %Here we fill in the history of the sensor
        %PS03
        rec=1;
        therecord.date={'9/03'};
        therecord.what={'deployed PS03'};
        therecord.host={'115'};
        therecord.comments={''};
        CTDsensorinfo.records{rec}=therecord;
        rec=rec+1;
        therecord.date={'12/03'};
        therecord.what={'recovered PS03'};
        therecord.host={'115'};
        therecord.comments={''};
        CTDsensorinfo.records{rec}=therecord;
        rec=rec+1;
    case 'SBE-MP52-002',
        CTDsensorinfo.type='SBE CTD 43F w/ oxygen';
        CTDsensorinfo.owner='Alford';
        %Here we fill in the history of the sensor
        %PS03
        rec=1;
        therecord.date={'4/05'};
        therecord.what={'deployed HC05'};
        therecord.host={'115'};
        therecord.comments={''};
        CTDsensorinfo.records{rec}=therecord;
        rec=rec+1;
    case 'SBE-MP52-026',
        CTDsensorinfo.type='SBE CTD 43F w/ oxygen';
        CTDsensorinfo.owner='Alford';
        %Here we fill in the history of the sensor
        rec=1;
        therecord.date={'3/07'};
        therecord.what={'deployed MB07'};
        therecord.host={'105'};
        therecord.comments={''};
        CTDsensorinfo.records{rec}=therecord;
        rec=rec+1;
    case 'SBE-MP52-004',
        CTDsensorinfo.type='SBE CTD 43F w/ oxygen';
        CTDsensorinfo.owner='Alford';
        %Here we fill in the history of the sensor
        rec=1;
        therecord.date={'6/16'};
        therecord.what={'deployed FLEAT16'};
        therecord.host={'107'};
        therecord.comments={''};
        CTDsensorinfo.records{rec}=therecord;
        rec=rec+1;
      case 'SBE-MP52-123'
        CTDsensorinfo.type='SBE CTD 43F w/ oxygen';
        CTDsensorinfo.owner='Alford';
        %Here we fill in the history of the sensor
        rec=1;
        therecord.date={'9/16'};
        therecord.what={'deployed LAJIT2'};
        therecord.host={'105'};
        therecord.comments={''};
        CTDsensorinfo.records{rec}=therecord;
        rec=rec+1;
    otherwise
        error('Unknown SN')        
end
