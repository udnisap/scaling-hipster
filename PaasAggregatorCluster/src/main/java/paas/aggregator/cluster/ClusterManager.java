package paas.aggregator.cluster;


import com.hazelcast.config.Config;
import com.hazelcast.core.*;
import java.util.*;
import org.apache.log4j.Logger;


public class ClusterManager {

    private static ClusterManager clusterManager;
    private HazelcastInstance hazelcastInstance;
    private static final Logger log = Logger.getLogger(ClusterManager.class);
    private Member localMember;
    private Vector<Member> memberList;
    private String localMemberAddress;
    private ArrayList<String> membersAddressList;

    private ClusterManager() {
        hazelcastInstance = Hazelcast.newHazelcastInstance(new Config().setInstanceName(UUID.randomUUID().toString()));
    }


    public static ClusterManager getInstant() {
        if (clusterManager == null) {
            clusterManager = new ClusterManager();

        }
        return clusterManager;

    }

    public void initiate() {
        Cluster cluster = hazelcastInstance.getCluster();
        localMember = cluster.getLocalMember();
        memberList = new Vector<Member>();

        cluster.addMembershipListener(new MembershipListener() {
            public void memberAdded(MembershipEvent membersipEvent) {
                memberList.add(membersipEvent.getMember());
            }

            public void memberRemoved(MembershipEvent membersipEvent) {
                memberList.remove(membersipEvent.getMember());

            }
        });

        for (Member member : cluster.getMembers()) {
            memberList.add(member);
        }
    }



       //Return string list of all members in the cluster except local member
    public ArrayList<String> getMemberList(){
        membersAddressList = new ArrayList<String>(memberList.size());
        for(Member member:memberList){
            if(!member.equals(localMember)){
                membersAddressList.add(member.getInetSocketAddress().getAddress().toString().substring(1));
            }
        }
        return membersAddressList;
    }

    //return string address of the local member
    public String getLocalMemberAddress(){
        localMemberAddress = localMember.getInetSocketAddress().getAddress().toString().substring(1);
        return localMemberAddress;
    }






}
