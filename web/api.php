<?php

include 'config.php';

$ret = array();
try {
    $ret['status'] = array();
    if (!isset($_REQUEST['method'])) {
        throw new Exception("Method is not found", 404);
    } else {
        $method = $_REQUEST['method'];
        switch ($method) {
            case 'getInstances' :
                $ret['results'] = R::findAndExport('instance');
                break;
            
            case 'addInstances':
                $instance = R::dispense('instance');
                $instance->import($_REQUEST['data']);
                R::store($instance);
                break;
            
            case "status":
                $instance = isset($_REQUEST['instance']) ? $_REQUEST['instance'] : "";
                if (!$instance)
                    throw new Exception("Instance not found", 406);
                $ret['results'] = exec("../master/script.sh status $instance");
                break;

            case "deployToInstance":
                $instance = isset($_REQUEST['instance']) ? $_REQUEST['instance'] : "";
                if (!$instance)
                    throw new Exception("Instance not found", 406);
                
            case "deploy":
                $instance  = isset($instance)? $instance : "";
                if ($_FILES["file"]["error"] > 0) {
                    throw new Exception("Error uploading the file", 400);
                }
                $ret['results'] = exec("../master/script.sh deploy {$_FILES['file']['tmp_name']} $instance");
                break;
            case "createInstance":
		$typed = isset($_REQUEST['typed']) ? $_REQUEST['typed'] : "";
		$name = isset($_REQUEST['name']) ? $_REQUEST['name'] : "";
                if (!$typed){
                    throw new Exception("type not found", 406);
		}elseif (!$name) {
  		   throw new Exception("name not found", 406);
		} 
                $ret['results'] = exec("../master/script.sh create $typed $name");
                break;

		case "delete":
		$delapptype = isset($_REQUEST['delapptype']) ? $_REQUEST['delapptype'] : "";
		$delapp = isset($_REQUEST['delapp']) ? $_REQUEST['delapp'] : "";
                if (!$delapptype){
                    throw new Exception("app type not found", 406);
		}elseif (!$delapp) {
  		   throw new Exception("app not found", 406);
		} 
                $ret['results'] = exec("../master/script.sh delete $delapptype $delapp");
                break;
            default:
                throw new Exception("Method not allowed $method", 405);
                break;
        }
        $ret['status']['type'] = 'success';
        $ret['status']['code'] = 200;
    }
} catch (Exception $exc) {
    $ret['status'] = array('type' => 'error', 'code' => $exc->getCode(), 'message' => $exc->getMessage());
}
header('X-PHP-Response-Code:', true, $ret['status']['code']);
//http_response_code($ret['status']['code']);
echo json_encode($ret);
?>

