package com.jeeplus.modules.esign.web;

import com.alibaba.fastjson.JSONObject;
import com.jeeplus.common.sms.SMSUtils;
import com.jeeplus.modules.esign.bean.signflow.ServerResponseResult;
import com.jeeplus.modules.esign.exception.DefineException;
import com.jeeplus.modules.esign.service.SignFlowStartService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * 签署流程发起（e签宝）
 *
 * @author lgf
 * @version 2016-01-07
 */
@Controller
@RequestMapping(value = "${adminPath}/flowstart")
public class SignFlowStartController {

    @Autowired
    private SignFlowStartService signFlowStartService;

    protected static Logger logger = LoggerFactory.getLogger(SMSUtils.class);

    /**
     * 签署流程发起
     */
    @RequestMapping(value = {"/singStart"}, method = RequestMethod.GET)
    public ServerResponseResult signFlowStart(@RequestParam String flowId) {
        try {
            return signFlowStartService.signFlowStart(flowId);
        } catch (DefineException e) {
            logger.info("请求失败：" + e.getMessage());
            return ServerResponseResult.createByErrorMessage("请求失败！");
        }
    }

    /**
     * 回调结果保存
     */
    @RequestMapping("signResult/callBackSave")
    @ResponseBody
    public void callBackSave(@RequestParam JSONObject json) {
          signFlowStartService.callBackSave(json);
    }

    /**
     * 合同文件保存
     */
    @RequestMapping("saveFlowDoc")
    @ResponseBody
    public ServerResponseResult saveFlowDoc(@RequestParam String flowId) {
        try {
            signFlowStartService.saveFlowDoc(flowId);
            return ServerResponseResult.createBySuccess();
        } catch (DefineException e) {
            return ServerResponseResult.createByErrorMessage(e.getMessage());
        }
    }

}
