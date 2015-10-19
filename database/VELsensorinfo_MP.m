function VELsensorinfo=VELsensorinfo_MP(sn)
%function VElsensor=VELsensor_MP(sn)

VELsensorinfo.sn=sn;

switch sn
    case '1605',
        VELsensorinfo.type='FSI 2-D ACM';
        VELsensorinfo.owner='Toole';
    case '1607',
        VELsensorinfo.type='FSI 2-D ACM';
        VELsensorinfo.owner='Toole';
    case '1653',
        VELsensorinfo.type='FSI 2-D ACM';
        VELsensorinfo.owner='Toole';
    case '1654',
        VELsensorinfo.type='FSI 2-D ACM';
        VELsensorinfo.owner='Toole';
    case '1617',
        VELsensorinfo.type='FSI 2-D ACM';
        VELsensorinfo.owner='Toole';
    case '1660',
        VELsensorinfo.type='FSI 2-D ACM';
        VELsensorinfo.owner='IARC';
    case '1661',
        VELsensorinfo.type='FSI 2-D ACM';
        VELsensorinfo.owner='IARC';
    case '1728',
        VELsensorinfo.type='FSI 2-D ACM';
        VELsensorinfo.owner='Toole';
    case '1500',
        VELsensorinfo.type='FSI 2-D ACM';
        VELsensorinfo.owner='Toole';
    case '1597',
        VELsensorinfo.type='FSI 2-D ACM';
        VELsensorinfo.owner='Toole';
    case '1730',
        VELsensorinfo.type='FSI 2-D ACM';
        VELsensorinfo.owner='Toole';

    case '1869',
        VELsensorinfo.type='FSI 2-D ACM';
        VELsensorinfo.owner='Alford';
        %Here we fill in the history of the sensor
        therecord.date={'3/07'};
        therecord.what={'purchased'};
        therecord.host={'105'};
        therecord.comments={''};
    case '1668',
        VELsensorinfo.type='FSI 2-D ACM';
        VELsensorinfo.owner='Alford';
        %Here we fill in the history of the sensor
        therecord.date={'6/03'};
        therecord.what={'purchased'};
        therecord.host={'101'};
        therecord.comments={''};

        VELsensorinfo.records{1}=therecord;

        %PS03
        therecord.date={'9/03'};
        therecord.what={'deployed PS03'};
        therecord.host={'101'};
        therecord.comments={''};
        VELsensorinfo.records{2}=therecord;

        therecord.date={'12/03'};
        therecord.what={'recovered PS03'};
        therecord.host={'101'};
        therecord.comments={''};
        VELsensorinfo.records{3}=therecord;

        %AEG04

        therecord.date={'8/04'};
        therecord.what={'deployed AEG04'};
        therecord.host={'101'};
        therecord.comments={''};

        VELsensorinfo.records{4}=therecord;

        therecord.date={'11/04'};
        therecord.what={'recovered AEG04'};
        therecord.host={'101'};
        therecord.comments={''};

        VELsensorinfo.records{5}=therecord;


    case '1710',
        VELsensorinfo.type='FSI 2-D ACM';
        VELsensorinfo.owner='Alford';
        %Here we fill in the history of the sensor
        therecord.date={'12/03'};
        therecord.what={'purchased'};
        therecord.host={'102'};
        therecord.comments={''};
        VELsensorinfo.records{1}=therecord;

        %PS03
        therecord.date={'9/03'};
        therecord.what={'deployed PS03'};
        therecord.host={'102'};
        therecord.comments={''};
        VELsensorinfo.records{2}=therecord;

        therecord.date={'12/03'};
        therecord.what={'recovered PS03'};
        therecord.host={'102'};
        therecord.comments={''};
        VELsensorinfo.records{3}=therecord;

        %AEG04

        therecord.date={'8/04'};
        therecord.what={'deployed AEG04'};
        therecord.host={'102'};
        therecord.comments={''};

        VELsensorinfo.records{4}=therecord;

        therecord.date={'11/04'};
        therecord.what={'recovered AEG04'};
        therecord.host={'102'};
        therecord.comments={''};

        VELsensorinfo.records{5}=therecord;

    case '1711',
        VELsensorinfo.type='FSI 2-D ACM';
        VELsensorinfo.owner='Alford';
        %Here we fill in the history of the sensor
        therecord.date={'6/03'};
        therecord.what={'purchased'};
        therecord.host={'103'};
        therecord.comments={''};
        VELsensorinfo.records{1}=therecord;

        %PS03
        therecord.date={'9/03'};
        therecord.what={'deployed PS03'};
        therecord.host={'103'};
        therecord.comments={''};
        VELsensorinfo.records{2}=therecord;

        therecord.date={'12/03'};
        therecord.what={'recovered PS03'};
        therecord.host={'103'};
        therecord.comments={''};
        VELsensorinfo.records{3}=therecord;

        %AEG04

        therecord.date={'8/04'};
        therecord.what={'deployed AEG04'};
        therecord.host={'103'};
        therecord.comments={''};

        VELsensorinfo.records{4}=therecord;

        therecord.date={'11/04'};
        therecord.what={'recovered AEG04'};
        therecord.host={'103'};
        therecord.comments={''};

        VELsensorinfo.records{5}=therecord;
    case '1845',
        VELsensorinfo.type='FSI 2-D ACM';
        VELsensorinfo.owner='Alford';
        %Here we fill in the history of the sensor
        therecord.date={'6/06'};
        therecord.what={'purchased'};
        therecord.host={'104'};
        therecord.comments={'for HC MP'};

        VELsensorinfo.records{1}=therecord;
        
    case 'AQD 9340',
        VELsensorinfo.type='Norrtek Aquadopp HR';
        VELsensorinfo.owner='Alford';
        %Here we fill in the history of the sensor
        therecord.date={'9/15'};
        therecord.what={'recovered ArcticMix15'};
        therecord.host={'107'};
        therecord.comments={''};

        VELsensorinfo.records{1}=therecord;
        
  case  'AQD11419'
        VELsensorinfo.type='Norrtek Aquadopp HR';
        VELsensorinfo.owner='Alford';
        %Here we fill in the history of the sensor
        therecord.date={'2/14'};
        therecord.what={'recovered SP14'};
        therecord.host={'109'};
        therecord.comments={''};

        VELsensorinfo.records{1}=therecord;

    otherwise,
        error('Unknown VELsensor SN. Please edit VELsensorinfo_MP.m')

end

