goodgrasps = data(results1>0,:);
badgrasps = data(results1<1,:);


figure; plot3( goodgrasps(:,1),goodgrasps(:,2),goodgrasps(:,3), '*')
hold on; plot3(badgrasps(:,1),badgrasps(:,2), badgrasps(:,3), 'ro')