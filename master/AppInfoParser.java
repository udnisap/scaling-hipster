
public class AppInfoParser {


    public static void main(String[] args) {

       String response = args[0];
      String instanceType = args[1];
      String needInfo = args[2];
        if(response.length()<=0){
          System.exit(0);
         }
        if(instanceType.equals("openshift")){
            if(needInfo.equals("appurl")){
             String result = response.substring(response.indexOf("@")+1,response.indexOf("("));
              result = result.trim();
              System.out.print(result);
            }else if(needInfo.equals("gitrepo")){
                String result = response.substring(response.indexOf("Git URL:")+8,response.indexOf("SSH"));
                result = result.trim();
                System.out.print(result);
            }
        }else if(instanceType.equals("heroku")){
          if(needInfo.equals("appurl")){
                String result = response.substring(response.indexOf("Web URL")+8);
                result = result.trim();
                System.out.print(result);
            }else if(needInfo.equals("gitrepo")){
                String result = response.substring(response.indexOf("Git URL:")+8,response.indexOf("Owner"));
                result = result.trim();
                System.out.print(result);
        }

    }

}
}
