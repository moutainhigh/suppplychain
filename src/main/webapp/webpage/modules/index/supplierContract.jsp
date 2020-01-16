<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp" %>
<%
    response.setHeader("Pragma", "No-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<html>
<head>
    <title>供应商--等待签约</title>
    <meta name="decorator" content="default"/>
    <link href="${ctxStatic}/online/style.css" rel="stylesheet" type="text/css"/>
    <script src="${ctxStatic}/online/lgt-web.js"></script>
    <style>
        .chuangxin_logout {
            float: right;
            width: 168px;
            height: 45px;
            line-height: 45px;
            text-align: center;
            font-size: 18px;
            color: #ffffff !important;
            background: #ff1b2c;
            border-radius: 8px;
            margin-left: 25px;
            display: inline;
        }


    </style>
    <script>
        $(function () {
            //处理状态
            if (!$.isEmpty($("#orgState").val())) {
                if ($("#orgState").val() == "2") {
                    location.href = "${ctx}/logout";
                }
                if (($("#orgState").val() == "0" || $("#orgState").val() == "1") && !$.isEmpty($("#userId").val())) {
                    location.href = "${ctx}/sys/register/to-supplierSubmitData?id=" + $("#userId").val();
                    ;
                }
                if ($("#orgState").val() != "0" && $("#orgState").val() != "1" && $("#orgState").val() != "2" && $("#orgState").val() != "3") {
                    location.href = "${ctx}/logout";
                }
            }

            if ($.isEmpty($("#orgId").val())) {
                location.href = "${ctx}/logout";
            }

            if (!$.isEmpty($("#message").val())) {
                layer.msg($("#message").val(), {shift: 6});

                if ($("#message").val() == "签约成功！") {
                    setTimeout(function () {
                        location.href = "${ctx}/login";
                    }, 2000);
                } else if (!$.isEmpty($("#userId").val())) {
                    location.href = "${ctx}/sys/register/to-supplierContract?id=" + $("#userId").val();
                }
            }
        });

        //切换
        function successful(obj, index) {
            $("#a0 li").attr("class", "successfulB");
            $(obj).attr("class", "successfulA");
            $(".successful_xie_con").hide();
            $("#a0" + index).show();
        }

        //签约
        function contract() {
            if (!$("#mycheckbox").is(':checked')) {
                layer.msg('请先勾选同意以上平台协议！', {shift: 6});
                return;
            }
            // $("#layui-layer-shade100002").show();
            // $("#layui-layer100002").show();
            sureNew();
            //sendContractCode();
        }

        //发送授权码
        function sendContractCode() {
            $("#mgmtform").submit();

        }

        //授权确定
        function sure() {
            if ($.isEmpty($("#verify_code").val())) {
                $("#error_verify_code").text("请输入签约授权码！");
                setTimeout(function () {
                    $("#error_verify_code").text("");
                }, 2000);
                return;
            }
            $("#validateCode").val($("#verify_code").val());
            $("#mgmtform").submit();


/////发送验证码
            if (!$.isEmpty($("#mobile").val())) {
                $("#shouquan-phone").text($("#mobile").val());
                $.ajax({
                    async: true,
                    cache: true,
                    url: "${ctx}/sys/register/get-mobile-code?mobile=" + $("#mobile").val(),
                    data: {},
                    type: "get",
                    dataType: "text",
                    success: function (data, status, xhr) {
                        if (data == "000") {
                            layer.msg("验证码已发送，请注意查收短信");
                        } else if (data == "003") {
                            layer.msg("图形验证码错误");
                        } else if (data == "004") {
                            layer.msg("用户名不存在");
                        } else if (data == "005") {
                            layer.msg("手机号码不一致");
                        } else if (data == "006") {
                            layer.msg("手机号码已存在");
                        } else if (data == "007") {
                            layer.msg("手机号码或验证均不能为空");
                        } else {
                            layer.msg(data);
                        }
                    },
                    error: function (xhr, status, error) {
                        layer.msg(status);
                    }
                });
            } else {
                layer.msg("授权手机号不存在，无法授权！");
            }
        }


        //签约跳转
        function sureNew() {
            $.ajax({
                url: "${ctx}/thy/createSignFlow",
                type: "get",
                dataType: "json",
                success: function (data, status, xhr) {
                    console.log(data.data);
                    location.href = "${ctx}/signResult/singStart?flowId=" + data.data;
                },
                error: function (xhr, status, error) {
                    layer.msg(status);
                }
            });

        }
    </script>
</head>
<body>
<div class="header">
    <div class="header_con" style="width: 1150px;">
        <div class="logo1">
            <span style="border-left: 0px; font-weight: 600; letter-spacing: 2px; font-size: 25px;">创信供应链金融</span>
            <span style="margin-left: 15px;">供应商注册</span>
        </div>
    </div>
</div>


<form name="mgmtform" id="mgmtform" class="form-horizontal" enctype="multipart/form-data"
      action="${ctx}/sys/register/having-supplierContract" accept-charset="UTF-8" method="post">
    <input type="hidden" id="message" value="${message}"/>
    <input type="hidden" id="orgId" name="supplierEnterpriseId.id" value="${supplier_user.supplierEnterpriseId.id}"/>
    <input type="hidden" id="orgState" value="${supplier_user.supplierEnterpriseId.state}"/>
    <input type="hidden" id="userId" name="userId.id" value="${supplier_user.userId.id}"/>
    <input type="hidden" id="validateCode" name="validateCode" value=""/>
    <input type="hidden" id="mobile" name="supplierEnterpriseId.agencyPhone"
           value="${supplier_user.supplierEnterpriseId.agencyPhone}"/>
    <div class="successful clear">
        <div class="title_nav3">
            <span>1  注册账号</span>
            <span>2  提交资料</span>
            <span>3  实名认证</span>
            <span><font color="#ffffff">4 在线签约</font></span>
        </div>
        <div class="successful_xie">
            <div class="successful_xie_nav">
                <ul id="a0">
                    <li class="successfulA" onclick="successful(this,0)">用户注册服务协议</li>
                    <li class="successfulB" style="width: 155px;" onclick="successful(this,1)">
                        用户授权协议
                    </li>
                    <li class="successfulB" style="margin-left: 5px;" onclick="successful(this,2)">
                        e签宝用户隐私政策
                    </li>
                    <li class="successfulB" style="margin-left: 5px;display: none;" onclick="successful(this,3)">
                        安心签平台隐私条款
                    </li>
                </ul>
            </div>
            <div class="successful_xie_con" id="a00">
                <div class="hetong">
                    <div class="hetong_title">用户注册服务协议</div>
                    <div class="hetong_nei">
                        欢迎使用【创信供应链平台】（以下简称“平台”或“本平台”）服务。为了保障用户的权益，请用户确认使用平台服务前，已经详细阅读了本协议的所有内容。对于责任限制等特别重要条款，本文将用粗体标注，请予以重点关注。
                        <br/>第一章 总则
                        <br/>1.用户在平台注册并确认本协议的行为，表示用户已阅读、理解并同意本协议之所有内容。
                        <br/>2.鉴于网络服务的特殊性，本协议可由平台随时更新，且无需另行通知。用户在使用平台服务时，应关注并遵守其所适用的相关条款。
                        <br/>3.用户在使用平台服务之前，应仔细阅读本协议。如用户不同意本协议及/或平台随时对其的修改，用户可以主动取消平台服务；用户一旦使用平台服务，即视为用户已了解并完全同意本协议各项内容，包括本平台对本协议随时所做的任何修改，并成为平台用户。
                        <br/>4.平台拥有本协议在法律许可范围内的最终解释权。
                        <br/>第二章 定义
                        <br/>如无特别说明，下列用语在本协议中的含义为：
                        <br/>5.平台：指提供多样化创新金融服务的、旨在促进产业链上下游和谐发展的【创信供应链平台】。
                        <br/>6.平台用户：指加入平台的机构或个人用户。
                        <br/>7.见证机构：指平台认可的合作银行。
                        <br/>8.资金提供方：指根据国家法律法规可以开展融资业务的银行和非银行金融机构、商业保理公司、金融综合服务平台上的投资人等。
                        <br/>第三章 平台提供的服务
                        <br/>9.平台服务是由本平台向自然人或企业用户提供的服务，具体服务内容主要包括：融资申请服务、数据交互服务、信用评估服务、融资顾问服务、协助结算账户变更服务等，具体详情以本平台当时提供的服务内容为准。
                        <br/>10.本平台作为用户信息的收集方，不涉及用户的交易内容及其交易资金管理服务。用户的交易约定内容和风险应由约定双方各自承担。
                        <br/>第四章 平台收费
                        <br/>11.用户如申请通过本平台进行融资的，需向平台支付平台服务费，平台服务费的具体费用标准及收费方式以用户在申请融资时签署的《创信供应链平台服务协议》为准。
                        <br/>第五章 声明与承诺
                        <br/>12.用户通过本平台申请融资前，应向本平台提交必要的自然人身份信息或者企业名称、企业工商注册号、办公地址、企业人民银行征信信息、企业法人姓名、身份证明、企业开户行及账号等信息，或本平台认为必要的其他信息，并对提交的信息的准确性、真实性与完整性负责。平台有权根据用户具体情况予以拒绝发布或临时撤销。
                        <br/>13.用户确认：用户以网络页面点击确认通过平台申请融资的行为即视为对资金提供方发出要约，未经本平台的同意，用户不得随意撤销该等要约。
                        <br/>14.在使用“平台”服务前，用户确认并同意以下事项：
                        <br/>1)用户是具有法律规定的完全民事权利能力和民事行为能力，能够独立承担民事责任的自然人、法人或其他组织，且本协议内容不受用户所属地区的排斥。不具备前述条件的，用户应立即终止注册或停止使用本网站提供的服务。平台仅向符合完全民事权利能力与民事行为能力的自然人，或符合平台或平台关联实体相关规则的法人或其他组织提供服务。
                        <br/>2)用户同意，尽管平台会尝试提醒用户关于此类操作或告知用户后续处理方式，平台并不对任何由于用户提供资料有误而导致无法通知用户相关信息的情况负责。
                        <br/>3)平台协议项下任何权利或义务，都不得在未经平台同意的情况下被出售或转移到第三方自然人或法人。
                        <br/>4)任何用户与平台之间的电子邮件形式的沟通都被视为有效沟通。
                        <br/>15.用户同意并保证不得利用本平台服务从事侵害他人权益或违法之行为，若有违反者应负所有法律责任。上述行为包括但不限于：
                        <br/>1)冒用他人名义使用本平台服务。
                        <br/>2)涉嫌洗钱、套现或进行非法集资活动的。
                        <br/>3)从事任何可能含有电脑病毒或是可能侵害本平台服务系統、资料等行为。
                        <br/>4)侵犯本平台的商业利益，包括但不限于发布非经本平台许可的商业广告。
                        <br/>5)其他本平台有正当理由认为不适当之行为。
                        <br/>本平台在有合理理由怀疑用户进行了本条规定的违约行为时，有权对用户的账户进行调查。如果调查结果证实用户的账户确实存在上述违约行为，本平台有权锁定用户的账户并终止与用户的合作。用户理解并同意本平台不会就账户的冻结以及锁定提供任何赔偿或者补偿。
                        <br/>第六章 不可抗力及服务中断
                        <br/>16.本平台需要定期或不定期地对提供平台服务系统及其相关的设备进行检修或者维护，如因此类情况而造成网络服务（包括收费服务）在合理时间内的中断，本平台无需为此承担任何责任。本平台保留不经事先通知为维修保养、升级或其它目的暂停本服务任何部分的权利。
                        <br/>第七章 信息收集与披露
                        <br/>17.平台将严格履行相关法规，确保用户的资料安全。
                        <br/>18.用户同意本平台有权出于为用户提供综合化或专业化服务的目的视情况向其他任何用户认为必要的业务合作机构披露用户资料、保密信息及本协议等。本平台承诺将要求相关合作机构对用户资料、保密信息及本协议等承担保密义务。
                        <br/>19.本平台有权按照用户在平台上的行为自动追踪关于用户的某些资料。在不透露用户个人的隐私资料的前提下，本平台有权对整个用户数据库进行分析并对用户数据库进行商业上的利用。
                        <br/>20.在本平台提供的交易活动中，用户承诺对所取得的相关交易相对人信息只用于与交易相关的合法、合理用途。用户无权要求本平台提供其他用户的个人资料，除非符合以下任一条件：
                        <br/>a)用户已向法院起诉其他用户的在本平台活动中的违约行为且法院已受理立案；
                        <br/>b)其他有碍于用户收回融资本息或其他合法权益的情形。
                        <br/>第八章 责任范围及责任限制
                        <br/>21.平台仅是用户发布信息的渠道，平台不保证平台用户上传信息的真实性、充分性、可靠性、准确性、完整性和有效性，平台用户依赖于其独立判断进行交易，并对其做出的判断承担全部责任。
                        <br/>22.平台不对平台用户能否达成融资交易出具任何承诺或保证，亦不对已达成的融资交易的任何风险出具任何承诺或保证。
                        <br/>23.本平台仅承担本协议明确约定的直接责任。除本协议另有规定外，在任何情况下，本平台对本协议所承担的违约赔偿责任总额不超过向用户收取的当次平台服务费用总额。
                        <br/>第九章 商标、知识产权的保护
                        <br/>24.本平台或平台关联方拥有本平台网站内相应资料、技术及展现形式的知识产权。
                        <br/>25.未经许可，任何人不得擅自使用（包括但不限于：以非法的方式复制、传播、展示、镜像、上载、下载）、修改、传播本平台或平台关联方的知识产权。否则，本平台将依法追究法律责任。
                        <br/>第十章 其他
                        <br/>26.通知方式：
                        <br/>1)拨打客服电话、向客服邮箱发送邮件、传真、EMS等方式均视为客户的有效通知。
                        <br/>2)拨打客户电话、网站公告、平台站内信、手机短信，向客户指定邮箱发送邮件、传真、快递等方式均视为平台的有效通知。本平台不保证用户能够收到或者及时收到上述邮件（或传真或挂号邮件），且不对此承担任何后果，因此，在交易过程中用户应当及时登录到本网站查看和进行交易操作。因用户没有及时查看和对交易状态进行修改或确认或未能提交相关申请而导致的任何纠纷或损失，本平台不负任何责任。
                        <br/>3)如果本协议条款中的部分条款被有管辖权的法院认定为违法，那么这些条款并不影响其他条款的有效性并将应用其他有效条款按最接近双方意图的可能而推定。
                        <br/>4)本平台未行使或执行本协议任何权利或规定，不构成对前述权利或权益之放弃。
                        <br/>5)如本协议中的任何条款无论因何种原因完全或部分无效或不具有执行力，本协议的其余条款仍应有效并且有约束力。
                        <br/>27.平台依据本协议约定获得处理违法违规内容的权利，该权利不构成平台的义务或承诺，平台不能保证及时发现违法行为或进行相应处理。
                        <br/>28.在任何情况下，用户不应轻信借款、索要密码或其他涉及财产的网络信息。涉及财产操作的，请一定先核实对方身份，并请经常留意平台有关防范诈骗犯罪的提示。
                        <br/>第十一章 管辖
                        <br/>29.本协议经用户在线上确认勾选后生效。
                        <br/>30.本协议的订立、执行和解释及争议的解决均应适用中华人民共和国法律。
                        <br/>31.因本协议引起的或与本协议有关的任何争议，尽最大诚意进行友好协商，如果双方不能协商一致，则该争议由平台所在地有管辖权的人民法院管辖。
                        <br/>
                        <div class="zhang" style="display: none"><span>甲方（签章）：上海创信供应链管理有限公司</span>
                            <!-- <img class="sealpicture" src="/images/zhang.png" /> --></div>
                        <div class="zhang"><span>（签章）：${supplier_user.supplierEnterpriseId.name}</span>
                            <!-- <img class="sealpicture" src="/uploads/axsignaccount/sealpicture/22/YZQY20180914100203787381258700.png" /> -->
                        </div>
                        <div class="clear"></div>
                    </div>
                    <div class="clear"></div>
                </div>
            </div>
            <div class="successful_xie_con" id="a01" style="display: none;">
                <div class="hetong">
                    <div class="hetong_title">用户授权协议</div>
                    <div class="hetong_nei">
                        《用户授权协议》(以下简称“本协议”)是创信供应链管理有限公司（以下简称“本公司”） 创信供应链
                        平台（以下简称“本平台”）与用户（以下简称“您”）所订立的有效合约。您通过网络页面点击确认或以其他方式选择接受本协议，即表示您与本公司已达成协议并同意接受本协议的全部约定内容。
                        <br/>
                        <br/>在接受本协议之前，请您仔细阅读本协议的全部内容（特别是以粗体下划线标注的内容）。如您不同意本协议的内容，或无法准确理解本协议任何条款的含义，请不要进行确认及后续操作，一旦确认即视为您同意本协议全部内容。如果您对本协议有疑问的，请通过service@cx-gyl.com邮箱进行询问，其将向您解释。
                        <br/>
                        <br/>1、您不可撤销的授权本公司将您本人的身份信息资料提交给杭州天谷信息科技有限公司（以下简称“e签宝”）和第三方CA认证机构，由本公司协助您向e签宝申请由ＣＡ认证机构生成、e签宝代发的数字证书。如因您提供的申请数字证书的身份信息有误或冒用他人身份信息导致不利后果，由您承担因此产生的全部法律责任。
                        <br/>
                        <br/>2、您同意本平台采用电子合同的方式在本平台与您签订您与本平台进行交易需订立的协议，该协议可以有一份或者多份并且每一份具有同等法律效力。您或您的代理人根据有关协议及本网站的相关规则在本平台确认签署的电子合同即视为您本人真实意愿并以您本人名义签署的合同，具有法律效力。您应妥善保管自己的账户密码、手机验证码等账户信息，您通过前述方式订立的电子合同对合同各方具有法律约束力，您不得以账户密码或手机验证码等账户信息被盗用或其他理由否认已订立的合同的效力或不按照该等合同履行相关义务。
                        <br/>
                        <br/>3、您确认在签署文件之前已经仔细阅读过文件的相关内容并予以理解和接受，您认可您通过本网站签署的电子合同条款的相关内容。
                        <br/>
                        <br/>4、您根据本协议以及本网站的相关规则签署电子合同后，不得擅自修改该合同。本平台向您提供电子合同的保管查询、核对等服务，如对电子合同真伪或电子合同的内容有任何疑问，您可通过本网站的相关系统板块查阅有关合同并进行核对。如对此有任何争议，应以本平台记录的合同为准。
                        <br/>
                        <br/>5、您认可您在签订电子合同过程中提交的实名认证资料，并同意通过短信验证码或者人脸识别的方式进行意愿认证，以及认可因上述操作产生的电子证据；若因合同履行产生纠纷，就合同签订过程中产生的电子证据您不得提出异议，该证据可直接作为纠纷处理依据。
                        <br/>
                        <br/>6、双方在履行本协议的过程中，如发生争议，应协商解决。协商不成的，任何一方均可向被告住所地有管辖权的人民法院提起诉讼。
                        <div class="clear"></div>
                    </div>
                    <div class="clear"></div>
                </div>
            </div>
            <div class="successful_xie_con" id="a02" style="display: none;">
                <div class="hetong">
                    <div class="hetong_title">e签宝用户隐私政策</div>
                    <div class="hetong_nei">
                        欢迎访问杭州天谷信息科技有限公司的电子签名平台（以下简称“e签宝”或“我们”），本政策适用于我们提供的产品和服务，包括电子签名产品、存证服务、法律服务等。
                        <br/>我们希望通过本隐私政策向您说明，在使用“e签宝”服务时，我们如何收集、使用、存储、分享和转让您的个人信息，以及我们为您提供的访问、更改、删除和保护这些信息的方式。请您在使用“e签宝”服务前，务必仔细阅读并了解本隐私政策，在确认充分理解并同意后使用我们的产品或服务。在您使用或在我们更新本隐私政策后（我们会及时提示您更新的情况）继续使用“e签宝”的产品或服务，即意味着您同意本隐私政策（含更新版本）内容，并且同意我们按照本隐私政策收集、使用、存储、分享和转让您的相关信息。如对本政策内容有任何疑问、意见或建议，您可通过本隐私政策提供的各种联系方式与我们联系。
                        <br/>本政策将帮助您了解以下内容：
                        <br/>一、我们如何收集您的个人信息；
                        <br/>二、我们如何使用您的个人信息；
                        <br/>三、我们如何共享、转让、公开您的个人信息；
                        <br/>四、我们如何使用COOKIES技术；
                        <br/>五、我们如何存储您的个人信息；
                        <br/>六、我们如何保护您的个人信息；
                        <br/>七、您管理个人信息的权利；
                        <br/>八、未成年人个人信息保护；
                        <br/>九、免责声明；
                        <br/>十、如何联系我们；
                        <br/>十一、隐私政策的变更和修订。
                        <br/> 
                        <br/> 一、我们如何收集您的个人信息
                        <br/>我们根据合法、正当、必要的原则，收集为实现产品功能所需要的信息，并将收集信息进行合理使用。
                        <br/>我们会收集以下个人或企业信息：
                        <br/>（一）您在注册、开通时提供的信息
                        <br/>为便于我们提供服务，您在注册或开通服务时需要提供包括但不限于真实姓名、个人电话号码、电子邮箱、地址等个人身份信息。如您进行身份认证服务，我们还会收集您身份证/护照等身份证明、人脸识别照片、银行卡信息、手机号码、个人手写签名、手持身份证照片及其他您提供的认证信息。收集此类信息是为了满足相关法律法规的实名制要求，若您不提供此类信息，您将无法完成实名认证，亦无法以实名身份签发文件。
                        <br/>如您是法人单位，我们还会搜集您的公司营业执照信息或组织机构代码证信息、法定代表人姓名及有效证件号码或者身份证正反面照片、公司住所地、公司电话号码及公司对公银行账号信息。
                        <br/> 
                        <br/>（二）您在使用过程中提供的信息
                        <br/>我们会收集您主动上传至我们的材料，包含合同原文、哈希值或其他书面材料，该文件或材料可能涉及您的隐私信息或商业秘密。我们会对上述信息进行加密保存。除非您主动提交合同审阅的服务，我们不会主动收集或分析这些信息。若您提供的是他人的信息，包括姓名、电话号码、身份证号、收件地址、邮箱地址等个人隐私信息，您需确认获得对方授权且保证对方也知晓并同意受本隐私协议之约束，因您提供的信息造成他人损害的，将由您自行承担责任。同时，如果他人提出相反意见或者向我们明示不愿受本隐私协议约束的，我们将删除相关信息。
                        <br/>此外，为了保障我们服务的连续性及您的账户安全，我们会收集您的下述信息：
                        <br/>2.1 设备信息：设备型号、操作系统版本、唯一设备标识符、IP 地址信息。
                        <br/>2.2 软件信息：软件的版本号、浏览器类型。为确保操作环境的安全或提供服务所需（调用其他APP用于认证服务），我们会收集有关您使用的移动应用和其他软件的信息。
                        <br/>2.3 服务日志信息。您在使用我们服务时登录时间、操作内容及时间、服务故障信息等信息。
                        <br/>2.4 IP及位置信息。例如，我们可能会通过IP地址、GPS、WiFi或基站等途径获取您的地理位置信息。
                        <br/>2.5如果您使用我们的客服系统，我们将收集您的手机号、邮箱和以及您反馈的信息，用于与您取得联系和解决问题。
                        <br/> 
                        <br/>（三）第三方为实现签约目的提供给我们的信息
                        <br/>在获取您明确同意的情况下，我们会与e签宝的合作客户共享您的个人信息，如您授权e签宝的合作客户将您的姓名、身份证号、手机号码、邮箱地址、签署完成的电子文件共享至e签宝平台，您可以在本平台上查看、下载本平台上的信息或文件。
                        <br/> 
                        <br/>（四）其他信息
                        <br/>本隐私协议列明的内容并不能完整罗列并覆盖未来可能实现的所有功能和业务场景，我们将基于本政策未载明的其他特定目的收集您的信息，但会事先征求您的同意。
                        <br/> 
                        <br/>（五）征得授权同意的例外
                        <br/>根据相关法律法规规定，以下情形中收集您的个人信息无需征得您的授权同意：
                        <br/>5.1与国家安全、国防安全有关的；
                        <br/>5.2与公共安全、公共卫生、重大公共利益有关的；
                        <br/>5.3与犯罪侦查、起诉、审判和判决执行等有关的；
                        <br/>5.4出于维护个人信息主体或其他个人的生命、财产等重大合法权益但又很难得到您本人同意的；
                        <br/>5.5所收集的个人信息是您自行向社会公众公开的；
                        <br/>5.6从合法公开披露的信息中收集个人信息的，如合法的新闻报道、政府信息公开等渠道；
                        <br/>5.7根据您的要求签订合同所必需的或双方已在合同中另行约定的；
                        <br/>5.8用于维护所提供的产品或服务的安全稳定运行所必需的，例如处理产品或服务的故障；
                        <br/>5.9学术研究机构基于公共利益开展统计或学术研究所必要，且对外提供学术研究或描述的结果时，对结果中所包含的个人信息进行去标识化处理的；
                        <br/>5.10法律法规规定的其他情形。
                        <br/> 二、我们如何使用您的个人信息
                        <br/>我们将严格遵守法律法规及与您的约定，将收集到的信息进行如下使用：
                        <br/>（一）帮助您成为我们的会员；
                        <br/>（二）向您提供产品和服务，包括依托第三方完成的实名认证、意愿认证、存证等服务的合理使用；
                        <br/>（三）产品开发和服务优化；
                        <br/>（四）其他用途：当我们要将信息用于本政策未载明的其他用途或要将基于特定目的收集的信息用于其他目的时，会事先征求您的同意。
                        <br/>您的信息将会存储在e签宝的服务器上。为了让您有更好的体验、改善我们的服务或经您同意的其他用途，在符合相关法律法规的前提下，我们可能将通过某些服务所收集的信息用于我们的其他服务。例如，将您在使用我们某项服务时的信息，用于用户研究分析与统计等服务，但我们不会将我们存储在分析软件中的信息与您在应用程序中提供的个人身份信息相结合。
                        <br/> 
                        <br/>三、 我们如何共享、转让、公开披露您的个人信息
                        <br/>我们不会与任何公司、组织和个人共享您的个人信息，但以下情况除外：
                        <br/>（一）共享
                        <br/>1.1我们可能会根据法律法规规定、诉讼争议解决需要，或按行政、司法机关依法提出的要求，对外共享您的个人信息。
                        <br/>1.2与合作机构共享:
                        为实现本电子签约或服务目的，我们的某些服务将由我们和合作机构共同提供。我们会根据法律法规与合作伙伴共享您的某些个人信息。您的个人身份信息及签约信息需传输至电子认证服务机构(简称CA)、公证处、司法鉴定中心、区块链、互联网法院、仲裁委、第三方身份认证机构，由上述权威机构出具相应证明文件或处理案件等目的使用并保存。我们仅会出于合法、正当、必要的目的共享您的个人信息，并且只会共享提供服务所必要的个人信息。
                        <br/>1.3为了让您有更好的体验、改善我们的服务或经您同意的其他用途，在符合相关法律法规的前提下，我们可能将通过某些服务所收集的信息用于我们的其他服务。例如，将您在使用我们某项服务时的信息，用于用户研究分析与统计等服务。
                        <br/>1.4为了确保服务的安全，帮助我们更好地了解我们应用程序的运行情况，我们可能记录相关信息或将所收集到的信息用于大数据分析，例如，您应用程序的频率、故障信息、总体使用情况、性能数据或分析形成不包含任何个人信息的城市热力图或行业洞察报告等。我们可能对外公开并与我们的合作伙伴分享经统计加工后不含身份识别内容的信息，用于了解用户如何使用我们服务或让公众了解我们服务的总体使用趋势。
                        <br/> 
                        <br/>（二）转让
                        <br/>我们不会将您的个人信息转让给其他任何公司、组织和个人，但以下情形除外：
                        <br/>2.1随着“e签宝”业务的发展，我们及我们的关联公司有可能进行合并、收购、资产转让或其他类似的交易。如相关交易涉及到您的个人信息转让，我们会要求新持有您个人信息的公司、组织和个人继续受此政策约束，否则我们将要求该公司、组织和个人重新征得您的授权同意。
                        <br/>2.2在获得您明确同意的情形下转让，我们会向其他方转让我们已经获取的您的个人信息。
                        <br/> 
                        <br/>（三）披露
                        <br/>我们仅会在以下情况下，公开披露您的个人信息：
                        <br/>3.1已经获得您明确同意。
                        <br/>3.2在法律、法律程序、诉讼或政府主管部门强制性要求的情况下，我们可能会公开披露您的个人信息。
                        <br/>3.3法律法规规定的其他情形。
                        <br/> 
                        <br/>四、 我们如何使用COOKIE技术
                        <br/>在您使用我们的产品或服务时，我们的平台会自动接收并记录您的浏览器和计算机上的信息，其中包括您的 IP
                        地址，您生成的电子签章，软硬件特征信息、以及您需求的网页记录，COOKIE中的信息等。为确保网站正常运转，我们会在您的计算机或移动设备上存储名为Cookie的小数据文件。在您未拒绝接受COOKIE的情况下，COOKIE将被发送到您的浏览器，并储存在您的计算机硬盘。我们使用COOKIE储存您访问我们网站的相关数据，在您访问或再次访问我们的网站时，我们能识别您的身份，并通过分析数据为您提供更好更多的服务。您有权选择接受或拒绝接受COOKIE。您可以通过修改浏览器的设置以拒绝接受COOKIE，但是我们需要提醒您，因为您拒绝接受COOKIE，您可能无法使用依赖于COOKIE的部分功能。
                        <br/> 
                        <br/>五、 我们如何存储您的个人信息
                        <br/>（一）我们在中华人民共和国境内收集和产生的个人信息将存储在中华人民共和国境内。若为处理跨境业务，确需向境外机构传输境内收集的相关个人信息的，我们会按照法律、行政法规和相关监管部门的规定执行。我们会确保您的个人信息得到足够的保护，例如匿名化、加密存储等。
                        <br/>（二）我们仅在本政策所属目的所必须期间和法律法规要求的时限内存储您的个人信息。
                        <br/>（三）但在下列情况下，我们有可能因需符合法律要求，更改个人信息的存储时间：
                        <br/>3.1 为遵守适用的法律法规等有关规定；
                        <br/>3.2 为遵守法院判决、裁定或其他法律程序的规定；
                        <br/>3.3 为遵守相关政府机关或法定授权组织的要求；
                        <br/>3.4 我们有理由确信需要遵守法律法规等有关规定；
                        <br/>3.5 为执行相关服务协议或本政策、维护社会公共利益，为保护我们的客户、我们或我们的关联公司、其他用户或雇员的人身财产安全或其他合法权益所合理必需的用途。
                        <br/>（四）如我们停止运营“e签宝”的产品或服务，我们将及时停止继续收集您个人信息的活动，将停止运营的通知以逐一送达或公告的形式通知您，并对我们存储的个人信息进行删除或匿名化处理。
                        <br/> 
                        <br/>六、 我们如何保护您的个人信息
                        <br/>（一）对我们与之共享个人信息的公司、组织和个人，我们会与其签署严格的数据保护条款，要求其按照我们的说明、本隐私政策以及其他任何相关的保密和安全措施来处理个人信息。
                        <br/>（二）为了保障您的信息安全，我们在收集您的信息后，将采取各种隔离必要的措施保护您的信息。我们会将去标识化后的信息与可用于恢复识别个人的信息分开存储，确保在针对去标识化信息的后续处理中不重新识别个人。
                        <br/>（三）我们承诺我们将使信息安全保护达到业界领先的安全水平。为保障您的信息安全，我们致力于使用各种安全技术及配套的管理体系来尽量降低您的信息被泄露、毁损、误用、非授权访问、非授权披露和更改的风险。例如：通过网络安全软件（SSL）进行加密传输、信息加密存储、严格限制数据中心的访问。传输和存储个人敏感信息（含个人生物识别信息）时，我们将采用加密、权限控制、去标识化等安全措施。
                        <br/>（四）在不幸发生用户信息安全事件（泄露、丢失等）后，我们将按照法律法规的要求，及时向您告知：安全事件的基本情况和可能的影响、我们已采取或将要采取的处置措施、您可自主防范和降低风险的建议、对您的补救措施等。我们将及时将事件相关情况以邮件、信函、电话、推送通知等方式告知您，难以逐一告知用户信息主体时，我们会采取合理、有效的方式发布公告。
                        <br/> 
                        <br/>七、 您管理个人信息的权利
                        <br/>（一）访问您的个人信息
                        <br/>您可以通过访问www.esign.cn来查询、编辑您账号中的个人资料信息和支付信息、更改您的密码、添加安全信息或注销您的账户等。
                        <br/> 
                        <br/>（二）删除您的个人信息
                        <br/>您可以通过登陆账号的形式自行删除信息。
                        <br/>在以下情况发生时，您有权要求“e签宝”删除您的个人信息：
                        <br/>2.1我们没有征求您的明确同意，收集了您的个人信息。
                        <br/>2.2我们处理您的个人信息违反了法律法规要求。
                        <br/>2.3我们违反了与您的约定来使用和处理您的个人信息。
                        <br/>2.4您不再使用或注销了“e签宝”账号。
                        <br/>2.5我们停止对您提供服务。
                        <br/>若我们决定响应您的删除请求，我们还将同时尽可能通知从我们处获得您的个人信息的主体，并要求其及时删除（除非法律法规另有规定，或这些主体已独立获得您的授权）。基于业务的需要，为维护交易多方的利益，在本条第二款2.4的情形下，我们仍将保留您与实名认证、意愿认证、签署业务直接关联的个人信息。
                        <br/>如您仍想删除此部分信息，需您与业务全部相关方授权同意，我们在收到您与业务全部相关方共同的删除指令后，会将该业务涉及的您的个人信息进行删除。
                        <br/>当您或我们协助您删除相关信息后，因为适用的法律和安全技术，我们可能无法立即从备份系统中删除相应的信息，我们将安全地存储您的个人信息并避免任何进一步处理，直到备份可以清除或实现匿名。
                        <br/> 
                        <br/>（三）更正您的个人信息
                        <br/>当您发现收集、存储的其个人信息有错误或需要更新时，可通过www.esign.cn或联系客服予以更正。
                        <br/> 
                        <br/>八、 未成年人个人信息保护
                        <br/>若您是未满18周岁的未成年人，在使用我们的产品及相关服务前，应在您的父母或其他监护人监护、指导下共同阅读并同意本隐私政策；
                        <br/>我们根据国家相关法律法规的规定保护未成年人的个人信息，只会在法律允许、父母或其他监护人明确同意或保护未成年人所必要的情况下收集、使用、共享或披露未成年人的个人信息；如果我们发现在未事先获得可证实的父母或其他监护人同意的情况下收集了未成年人的个人信息，则会设法尽快删除相关信息。
                        <br/>若您是未成年人的监护人，当您对您所监护的未成年人的个人信息有相关疑问时，请通过本隐私政策公示的联系方式与我们联系。
                        <br/> 
                        <br/>九、 免责声明
                        <br/>（一）“e签宝”含有其他网站的链接，我们可能在任何需要的时候增加商业伙伴或共用品牌的网站。“e签宝”对您通过“e签宝”链接到其他网站需要的隐私保护不负任何责任。 
                        <br/>（二）因您个人原因导致账号密码泄露从而导致个人信息泄露的，“e签宝”不负任何责任，但我们会积极地配合您找回密码或更改密码。
                        <br/> 
                        <br/>十、 如何联系我们
                        <br/>如果您对我们的隐私政策及对您个人信息的处理有任何疑问、意见、建议或投诉，可通过客服电话400-087-8198或0571-85785223来反馈，我们提供7*24小时的热线服务。
                        <br/> 
                        <br/>十一、 隐私政策的变更和修订
                        <br/>我们可能适时修订本政策内容。如该等变更会导致您在本政策项下权利的实质减损，我们将在变更生效前，通过在页面显著位置提示、向您发送电子邮件等方式通知您。在该种情况下，若您继续使用我们的服务，即表示同意受经修订的政策约束。
                        <div class="clear"></div>
                    </div>
                    <div class="clear"></div>
                </div>
            </div>
            <div class="successful_xie_con" id="a03" style="display:none;">
                <div class="hetong">
                    <div class="hetong_title">安心签平台隐私条款</div>
                    <div class="hetong_nei">
                        <b>隐私声明</b><br/>
                        欢迎使用安心签平台！对于您的隐私，我们绝对尊重并予以保护，本隐私声明将告诉您，安心签平台（所涉域名为：www.anxinsign.com）收集资料与运用的方式以及我们的隐私保护政策。本站的隐私声明正在不断改进中，随着我站服务范围的扩大，我们会随时更新我们的隐私声明。<br/>
                        在同意安心签平台服务协议（以下简称“协议”）之时，您已经同意我们按照本隐私声明来使用和披露您的个人信息。本隐私声明的全部条款属于协议的一部分。<br/>
                        <b>未成年人的特别注意事项</b><br/>
                        如果您未满18周岁，您无权使用本公司服务，因此我们希望您不要向我们提供任何个人信息。<br/>
                        <b>数字证书、用户名和密码</b><br/>
                        当您注册成用户时，我们要求您选择一个用户名和密码。您可以通过（a）使用您专有的数字证书和PIN码（b）您的用户名和密码，两种方式登录平台。如果您丢失了数字证书或泄漏了PIN码/密码，您可能丢失了您的个人识别信息，并且可能出现对您不利的后果。因此，无论任何原因危及您的数字证书安全或PIN/密码安全，您应该立即通过安心签平台公布的联系方式和我们取得联系。<br/>
                        <b>注册信息</b><br/>
                        当您在注册为用户时，我们要求您填写注册信息。如果您是个人用户，注册信息包括您的真实姓名、证件类型、证件号码、电话号码、地址和电子邮件地址；如果您是企业用户，注册信息包括公司名称、证件类型、证件号、公司电话、公司地址、公司邮箱、法人代表真实姓名、经办人真实姓名、经办人的证件类型、经办人的证件号码、经办人的电话号码、经办人的地址和经办人的电子邮件地址。另外，您还被要求提供法人代表对经办人的注册和运营安心签平台账户的授权书原件。我们通过（a）比较您的注册信息和您专有的数字证书的信息来判断您的真实身份，作为是否为您提供服务的依据；（b）比较您的注册信息和您提交的相关证件复印件/原件来判断是否给您颁发有效的数字证书，并作为是否为您提供服务的依据；（c）在获得您本人同意的情况下，委托有合法资质的第三方机构对您的身份信息进行核实，作为是否为您提供服务的依据。<br/>
                        <b>银行账号</b><br/>
                        我们的一些服务需要付费，我们会合理获取您的银行账号信息。<br/>
                        <b>您的用户行为</b><br/>
                        为了提供并优化您需要的服务，我们会根据合理性、必要性原则收集您使用服务的相关信息，这类信息包括：在您使用安心签服务访问网页时，自动接收并记录的您的浏览器和计算机上的信息，包括您的IP地址、浏览器的类型、访问日期和时间、软硬件特征信息及您需求的网页记录等数据；如您下载或使用安心签客户端软件，或访问移动网页使用安心签服务时，我们可能会读取与您位置和移动设备相关的信息，包括设备型号、设备识别码、操作系统、分辨率、电信运营商等。<br/>
                        除上述信息外，我们还可能为了提供服务及改进服务质量的合理需要而收集您的其他信息，包括您与我们的客户服务团队联系时您提供的相关信息，您参与问卷调查时向我们发送的问卷答复信息。与此同时，为提高您使用安心签提供的服务的安全性，更准确地预防钓鱼网站欺诈和木马病毒，我们可能会通过了解一些您的网络使用习惯等手段来判断您账户的风险。<br/>
                        我们保证将采取严格的保密措施保护您的信息不被泄露，并仅将该信息用于上述目的。<br/>
                        <b>Cookie的使用</b><br/>
                        cookies是少量的数据，在您未拒绝接受cookies的情况下，cookies将被发送到您的浏览器，并储存在您的计算机硬盘中。我们使用cookies储存您访问我们平台的相关数据，在您访问或再次访问我们的平台时，我们能识别您的身份，并通过分析数据为您提供更好更多的服务。
                        <br/>
                        您有权选择接受或拒绝接受cookies。您可以通过修改浏览器的设置以拒绝接受cookies，但是我们需要提醒您，因为您拒绝接受cookies，您可能无法使用依赖于cookies的我们网站的部分功能。<br/>
                        <b>信息的披露和使用</b><br/>
                        我们不会向任何无关第三方提供、出售、出租、分享和交易用户信息，但为方便您使用安心签平台服务及安心签平台关联公司或其他组织的服务（以下称“其他服务”），您同意并授权安心签平台将您的用户信息传递给您同时接受其他服务的安心签平台关联公司或其他组织，或从为您提供其他服务的安心签平台关联公司或其他组织获取您的用户信息，法律禁止的除外。如您不同意该等信息共享，您可向本公司发送书面声明，本公司将尊重您的意愿及选择。<br/>
                        您同意我们可批露或使用您及（或）您的公司的用户信息以用于识别和（或）确认您的身份，或解决争议，或有助于确保网站安全、限制欺诈、非法或其他刑事犯罪活动，以执行我们的服务协议。<br/>
                        您同意我们可批露或使用您及（或）您的公司的用户信息以保护您的生命、财产之安全或为防止严重侵害他人之合法权益或为公共利益之需要。<br/>
                        您同意我们可批露或使用您及（或）您的公司的用户信息以改进我们的服务，并使我们的服务更能符合您的要求，从而使您在使用我们服务时得到更好的用户体验。<br/>
                        您同意我们利用您及（或）您的公司的用户信息与您联络，并向您提供您感兴趣的信息，如：服务到期提醒。<br/>
                        当我们被法律强制或依照政府或依权利人因识别涉嫌侵权行为人的要求而提供您的信息时，我们将善意地披露您的资料。<br/>
                        <b>信息的存储和交换</b><br/>
                        所收集的用户信息和资料将加密保存在安心签平台及（或）其关联公司的服务器上。<br/>
                        <b>外部链接</b><br/>
                        平台可能含有到其他网站的链接。我们对那些网站的隐私保护措施不负任何责任。我们可能在任何需要的时候增加商业伙伴或共用品牌的网站。<br/>
                        <b>安全</b><br/>
                        我们平台有相应的安全措施来确保我们掌握的信息不丢失，不被滥用和篡改。这些安全措施包括向其它服务器备份数据和对用户信息加密。尽管我们有这些安全措施，但请注意，在因特网上不存在“绝对安全的安全措施”。<br/>
                        <b>修改您的资料</b><br/>
                        您可以在安心签平台上修改或者更新您的登录密码、电话号码、地址和电子邮件地址（在成功登录之后）。若您为公司用户，变更法人代表、经办人时，我们需要您重新提交相应的证明文件复印件和授权书原件。<br/>
                        <b>联系我们</b><br/>
                        如果您对本隐私声明或安心签平台的隐私保护措施以及您在使用时有任何意见和建议，欢迎通过安心签平台公布的联系方式和我们联系。<br/>
                        <b>法律声明</b><br/>
                        若要访问和使用安心签平台服务，您必须不加修改地完全接受本协议中所包含的条款、条件和安心签平台即时刊登的通告，并且遵守有关互联网及/或本平台的相关法律、规定与规则。一旦您使用安心签平台服务，即表示您同意并接受了所有该等条款、条件及通告。<br/>
                        <b>版权和商标</b><br/>
                        安心签平台所有的版权权利均在全世界范围内受到法律保护，除非有其他的标注或在此等条款和规则中被允许使用，本网站上可阅读和可见的所有资料都受到知识产权法的保护。<br/>
                        安心签平台拥有的所有版权和商标未经书面同意，不得以任何非法手段侵犯。对于已经授权的版权或者商标用途，只能使用于授权时指定的范围。任何人不得利用工作之便获取版权和商标。<br/>
                        <b>保密条款</b><br/>
                        任何人均需严格遵守安全保密条款，保护各方商业秘密及相关权益，包括但不限于产品知识产权、策划方案、客户资料、协议合同、技术文档、程序文件、程序控件或源代码、各种账户密码。任何人不得泄漏他人的任何商业秘密，同时不得利用工作之便获取他人技术秘密。对于授权使用的技术，只能使用于授权时指定的范围，不得用于它途。<br/>

                        <br>
                        <div class="clear"></div>
                    </div>
                    <div class="clear"></div>
                </div>
            </div>
            <div class="reg_yue clear">
                <input id="mycheckbox" type="checkbox" class="checkbix" style="margin: 0;"/>
                <label aria-label="" role="checkbox" for="mycheckbox" class="checkbix"><span class=""></span></label>
                <div style="margin-left: 0px; display: inline-block; margin-top: -40px;">我方已认真阅读并同意接受《用户注册服务协议》<span>、《用户授权协议》、《e签宝用户隐私政策》</span>
                </div>
            </div>
            <div class="successful_xie_bot clear">
                <a href="${ctx}/logout" class="chuangxin_logout" data-kid="503">关闭</a>
                <c:if test="${fn:contains(fns:getUser().roleNames, '供应商负责人')}">
                    <a href="javascript: void(0);" class="successful_a" id="sign" onclick="contract()" data-kid="503"
                       data-pcode="20180914195816982987838600">马上签约</a>
                </c:if>
                <c:if test="${not fn:contains(fns:getUser().roleNames, '供应商负责人')}">
                    <a href="javascript: void(0);" style="background-color: #a0a0a0;" class="successful_a" id="sign"
                       data-kid="503" data-pcode="20180914195816982987838600">无签约权限</a>
                </c:if>
            </div>
            <div class="clear"></div>
        </div>
        <div class="clear"></div>
    </div>
</form>

<div class="reg_footer" style="height: 94px; line-height: 25px;">
    <span>咨询热线：000-0000000 9:00 -- 18:00（周一至周五）</span>
    <br>
    <span>版权所有 ©2018 上海创信供应链管理有限公司 沪ICP备 <a href="http://www.miitbeian.gov.cn" target="_blank">18038558</a>号</span>
</div>

<div class="layui-layer-shade" id="layui-layer-shade100002" times="100002"
     style="z-index:19991015; display: none; background-color:#000; opacity:0.8; filter:alpha(opacity=80);"></div>

<div class="layui-layer layui-layer-iframe  layer-anim" id="layui-layer100002" type="iframe" times="100002" showtime="0"
     contype="string" style="display: none; z-index: 19991016; width: 30%; height: 214px; top: 230px; left: 531.5px;">
    <div class="layui-layer-title" style="cursor: move;">签约手机授权码</div>
    <div class="layui-layer-content">
        <div class="popup_nei2 clear" style="height: 120px;">
            为了您的账户安全，请输入授权码<br>授权码已发送至手机号：<b id="shouquan-phone"></b>
            <br/>
            <input type="text" style="margin-top: 10px;" class="disclose_text1" id="verify_code" name="verify_code"
                   value="" placeholder="请输入授权码"/>
            <span class="disclose_r" id="error_verify_code" style="margin-top: 9px;"></span>
        </div>
        <div class="popup_bot clear">
            <a href="javascript:void(0);" onclick="sure()" class="popup_a">确定</a>
        </div>
        <div class="clear"></div>
    </div>
</div>

</body>
</html>