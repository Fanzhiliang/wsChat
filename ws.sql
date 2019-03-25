/*
 Navicat Premium Data Transfer

 Source Server         : ws
 Source Server Type    : MySQL
 Source Server Version : 50557
 Source Host           : 120.78.128.4:3306
 Source Schema         : ws

 Target Server Type    : MySQL
 Target Server Version : 50557
 File Encoding         : 65001

 Date: 25/03/2019 23:07:19
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for ws_apply
-- ----------------------------
DROP TABLE IF EXISTS `ws_apply`;
CREATE TABLE `ws_apply`  (
  `apply_id` int(11) NOT NULL AUTO_INCREMENT,
  `creater_id` int(11) NOT NULL,
  `target_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `apply_type` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `content` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `write_date` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`apply_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 49 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for ws_carte
-- ----------------------------
DROP TABLE IF EXISTS `ws_carte`;
CREATE TABLE `ws_carte`  (
  `carte_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `carte` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `integral` int(11) NOT NULL DEFAULT 0,
  `last_date` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`carte_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 31 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of ws_carte
-- ----------------------------
INSERT INTO `ws_carte` VALUES (1, 2, 1, '脑残一号', 22, 1544259539);
INSERT INTO `ws_carte` VALUES (2, 6, 1, '我是群主', 333, 1550244562);
INSERT INTO `ws_carte` VALUES (3, 3, 1, 'cyh', 12, 1553501225);
INSERT INTO `ws_carte` VALUES (28, 9, 1, 'xxl', 0, 1550151529);
INSERT INTO `ws_carte` VALUES (30, 6, 4, 'fzl', 0, 1550241451);

-- ----------------------------
-- Table structure for ws_code
-- ----------------------------
DROP TABLE IF EXISTS `ws_code`;
CREATE TABLE `ws_code`  (
  `code_id` int(11) NOT NULL AUTO_INCREMENT,
  `code` int(6) NULL DEFAULT NULL,
  `time` int(11) NOT NULL,
  `code_type` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`code_id`) USING BTREE,
  UNIQUE INDEX `code`(`code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for ws_dynamic
-- ----------------------------
DROP TABLE IF EXISTS `ws_dynamic`;
CREATE TABLE `ws_dynamic`  (
  `dynamic_id` int(11) NOT NULL AUTO_INCREMENT,
  `creater_id` int(11) NOT NULL,
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `write_date` int(11) NOT NULL,
  `address` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '',
  `like_ids` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `img_srcs` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  PRIMARY KEY (`dynamic_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 44 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of ws_dynamic
-- ----------------------------
INSERT INTO `ws_dynamic` VALUES (1, 2, '<p>2018.11.03~2018.11.10 <br></p><p>很开心认识了新加坡的Tina，北京的霍大哥，胡志明的越南小哥。</p><p>\r\nWelcome to China. <br></p><p><br></p><p>旅行同时思考思考自己。一次开心放松的旅行，感恩所见到的一切 <br></p><p>\r\n图一图二是一组，图四图五是一组</p><p></p>', 1544428001, '广东省广州市南沙区横沥镇新村中心村五街四号', '3,6', '[\"static/img/test-1.jpg\",\"static/img/test-2.jpg\",\"static/img/test-3.jpg\",\"static/img/test-1.jpg\",\"static/img/test-2.jpg\",\"static/img/test-3.jpg\",\"static/img/test-1.jpg\",\"static/img/test-2.jpg\",\"static/img/test-3.jpg\"]');
INSERT INTO `ws_dynamic` VALUES (2, 3, '<p>美好的一天~</p>', 1544427341, '广东省佛山市顺德区', '6', NULL);
INSERT INTO `ws_dynamic` VALUES (3, 2, '<p>2018.11.03~2018.11.10 <br></p><p>很开心认识了新加坡的Tina，北京的霍大哥，胡志明的越南小哥。</p><p>', 1544427395, '广东省广州市南沙区', '3,6', '[\"static/img/test-1.jpg\",\"static/img/test-2.jpg\",\"static/img/test-3.jpg\",\"static/img/test-1.jpg\",\"static/img/test-2.jpg\",\"static/img/test-3.jpg\",\"static/img/test-1.jpg\"]');
INSERT INTO `ws_dynamic` VALUES (4, 3, '<p>我是不存在的用户</p>', 1544427495, '广东省中山市', '3', '[\"static/img/test-1.jpg\",\"static/img/test-2.jpg\",\"static/img/test-3.jpg\",\"static/img/test-1.jpg\",\"static/img/test-2.jpg\",\"static/img/test-3.jpg\"]');
INSERT INTO `ws_dynamic` VALUES (5, 2, '<p>我也能找到吗？</p>', 1544427595, '广东省广州市南沙区', '6', '[\"static/img/test-1.jpg\",\"static/img/test-2.jpg\",\"static/img/test-3.jpg\",\"static/img/test-1.jpg\",\"static/img/test-2.jpg\"]');
INSERT INTO `ws_dynamic` VALUES (6, 3, '<p>我笑了<img src=\"./static/img/fFace/fFace_01.png\" alt=\"face\"></p>', 1544427695, '广东省佛山市顺德区', '3,6', NULL);
INSERT INTO `ws_dynamic` VALUES (7, 2, '<p>在仅有一次的生命里。</p>', 1544427795, '广东省广州市南沙区', '3,6', NULL);
INSERT INTO `ws_dynamic` VALUES (8, 6, '<p>我也能找到吗？在仅有一次的生命里。</p>', 1544427895, '广东省广州市南沙区横沥镇新村中心村五街四号', '6', '[\"static/img/test-1.jpg\",\"static/img/test-2.jpg\",\"static/img/test-3.jpg\",\"static/img/test-1.jpg\"]');
INSERT INTO `ws_dynamic` VALUES (9, 2, '<p>alcyh</p>', 1544427995, '广东省广州市南沙区', '6', '[\"static/img/test-1.jpg\",\"static/img/test-2.jpg\",\"static/img/test-3.jpg\"]');
INSERT INTO `ws_dynamic` VALUES (10, 3, '<p>我的思想出问题了。</p>', 1544427999, '广东省佛山市顺德区', '6', '[\"static/img/test-1.jpg\",\"static/img/test-2.jpg\"]');
INSERT INTO `ws_dynamic` VALUES (11, 2, '<p>下路叫我去我怎么去，对面螳螂一直进我野区！</p>', 1544428000, '广东省广州市南沙区', '3,6', '[\"static/img/test-1.jpg\"]');
INSERT INTO `ws_dynamic` VALUES (21, 6, '<p>上传图片测试</p>', 1545126540, '广东省广州市广东技术师范学院天河学院', NULL, '[\"http://www.test3.com/wsChat/resources/6_1545126540_0.jpg\",\"http://www.test3.com/wsChat/resources/6_1545126540_1.jpg\",\"http://www.test3.com/wsChat/resources/6_1545126540_2.jpg\"]');
INSERT INTO `ws_dynamic` VALUES (22, 2, '<p>我是小良xl<img src=\"./static/img/fFace/fFace_05.png\" alt=\"face\" data-w-e=\"1\"></p>', 1545228624, '广东省广州市广东技术师范学院天河学院', NULL, '[\"http://www.test3.com/wsChat/resources/2_1545228624_0.jpg\"]');
INSERT INTO `ws_dynamic` VALUES (29, 6, '<p>xl并不能看到这个动态</p>', 1545233445, '广东省广州市广东技术师范学院天河学院', NULL, '[]');
INSERT INTO `ws_dynamic` VALUES (36, 6, '<p>明天开始一定好好当人，继续完成毕业设计。<img src=\"./static/img/fFace/fFace_31.png\" alt=\"face\" data-w-e=\"1\" style=\"width: 18px; height: 18px; margin: 0px 1px; vertical-align: middle;\"></p>', 1546866911, '', '2,6', '[\"http://www.test3.com/wsChat/resources/6_1546866911_0.jpg\"]');
INSERT INTO `ws_dynamic` VALUES (38, 2, '<p>我去洗澡了886~<img src=\"./static/img/fFace/fFace_03.png\" alt=\"face\" data-w-e=\"1\" style=\"width: 18px; height: 18px; margin: 0px 1px; vertical-align: middle;\"></p>', 1546867370, '广东省广州市白云区', '6', '[\"http://www.test3.com/wsChat/resources/2_1546867370_0.png\",\"http://www.test3.com/wsChat/resources/2_1546867370_1.jpg\"]');
INSERT INTO `ws_dynamic` VALUES (41, 6, '<p>快过年啦~<img src=\"./static/img/fFace/fFace_02.png\" alt=\"face\" data-w-e=\"1\"></p>', 1548836139, '广东省广州市天河区', NULL, '[\"http://www.test3.com/wsChat/resources/6_1548836139_0.jpg\"]');
INSERT INTO `ws_dynamic` VALUES (42, 2, '<p>新年快乐~<img src=\"./static/img/fFace/fFace_02.png\" alt=\"face\" data-w-e=\"1\"></p>', 1549616098, '广东省广州市南沙区', NULL, '[]');
INSERT INTO `ws_dynamic` VALUES (43, 9, '<p>快毕业了<img src=\"./static/img/fFace/fFace_09.png\" alt=\"face\" data-w-e=\"1\"></p>', 1552129286, '广东省广州市白云区', NULL, '[]');

-- ----------------------------
-- Table structure for ws_dynamicMsg
-- ----------------------------
DROP TABLE IF EXISTS `ws_dynamicMsg`;
CREATE TABLE `ws_dynamicMsg`  (
  `dynamicMsg_id` int(11) NOT NULL AUTO_INCREMENT,
  `creater_id` int(11) NOT NULL,
  `dynamic_id` int(11) NOT NULL,
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `write_date` int(11) NOT NULL,
  `callUser_id` int(11) NOT NULL,
  PRIMARY KEY (`dynamicMsg_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 43 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of ws_dynamicMsg
-- ----------------------------
INSERT INTO `ws_dynamicMsg` VALUES (1, 3, 1, '<p>出门在外，注意安全。<img src=\"./static/img/fFace/fFace_01.png\" alt=\"face\"></p>', 1544427333, 0);
INSERT INTO `ws_dynamicMsg` VALUES (2, 6, 1, '<p>肩背一匹布，手提一瓶醋，走了一里路，看见一只兔，卸下布，放下醋，去捉兔。跑了兔，丢了布，洒了醋。</p>', 1544427337, 0);
INSERT INTO `ws_dynamicMsg` VALUES (4, 6, 11, '<p>你怎么不放大招啊？</p>', 1544626966, 0);
INSERT INTO `ws_dynamicMsg` VALUES (5, 6, 11, '<p>下路不放大！</p>', 1544662790, 0);
INSERT INTO `ws_dynamicMsg` VALUES (6, 6, 11, '<p>高地不放大！</p>', 1544662838, 0);
INSERT INTO `ws_dynamicMsg` VALUES (7, 6, 11, '<p>死了放个空大！</p>', 1544662886, 0);
INSERT INTO `ws_dynamicMsg` VALUES (8, 6, 11, '<p>明明是酒桶进你的野区。。。</p>', 1544663681, 0);
INSERT INTO `ws_dynamicMsg` VALUES (9, 6, 11, '<p>行吧</p>', 1545042805, 0);
INSERT INTO `ws_dynamicMsg` VALUES (10, 6, 11, '<p>我发个表情<img src=\"./static/img/fFace/fFace_02.png\" alt=\"face\" data-w-e=\"1\"></p>', 1545042831, 0);
INSERT INTO `ws_dynamicMsg` VALUES (11, 6, 10, '<p>关我什么事？</p>', 1545043273, 0);
INSERT INTO `ws_dynamicMsg` VALUES (12, 6, 5, '<p>回复下你，显得不尴尬</p>', 1545043484, 0);
INSERT INTO `ws_dynamicMsg` VALUES (13, 6, 4, '<p>我喜欢你</p>', 1545043507, 0);
INSERT INTO `ws_dynamicMsg` VALUES (14, 6, 10, '<p>123321</p>', 1545043626, 0);
INSERT INTO `ws_dynamicMsg` VALUES (15, 6, 9, '<p>1234567</p>', 1545043633, 0);
INSERT INTO `ws_dynamicMsg` VALUES (16, 6, 10, '<p>出现了bug</p>', 1545043700, 0);
INSERT INTO `ws_dynamicMsg` VALUES (17, 6, 10, '<p>我服了</p>', 1545043819, 0);
INSERT INTO `ws_dynamicMsg` VALUES (18, 6, 9, '<p>我醉了</p>', 1545043841, 0);
INSERT INTO `ws_dynamicMsg` VALUES (19, 6, 10, '<p>但是我会解决它</p>', 1545043887, 0);
INSERT INTO `ws_dynamicMsg` VALUES (20, 6, 10, '<p>才怪呢~</p>', 1545043924, 0);
INSERT INTO `ws_dynamicMsg` VALUES (21, 6, 9, '<p>来吧</p>', 1545043931, 0);
INSERT INTO `ws_dynamicMsg` VALUES (22, 6, 12, '<p>添加测试1</p>', 1545126100, 0);
INSERT INTO `ws_dynamicMsg` VALUES (23, 6, 20, '<p>7777</p>', 1545126166, 0);
INSERT INTO `ws_dynamicMsg` VALUES (24, 2, 29, '<p>看到了喔~<img src=\"./static/img/fFace/fFace_08.png\" alt=\"face\" data-w-e=\"1\" style=\"background-color: rgb(255, 255, 255);\"></p>', 1545233566, 0);
INSERT INTO `ws_dynamicMsg` VALUES (25, 2, 29, '<p><img src=\"./static/img/fFace/fFace_01.png\" alt=\"face\" data-w-e=\"1\"><br></p>', 1545233615, 0);
INSERT INTO `ws_dynamicMsg` VALUES (26, 2, 29, '<p>这个冒汗表情有问题啊</p>', 1545234470, 0);
INSERT INTO `ws_dynamicMsg` VALUES (27, 6, 22, '<p>嗯，知道了。</p>', 1545234500, 0);
INSERT INTO `ws_dynamicMsg` VALUES (28, 2, 29, '<p>你看到了吗？</p>', 1545234831, 0);
INSERT INTO `ws_dynamicMsg` VALUES (29, 6, 22, '<p><img src=\"./static/img/fFace/fFace_08.png\" alt=\"face\" data-w-e=\"1\"></p>', 1545268077, 0);
INSERT INTO `ws_dynamicMsg` VALUES (31, 6, 22, '<p><img src=\"./static/img/fFace/fFace_08.png\" alt=\"face\" data-w-e=\"1\" style=\"width: 18px; height: 18px; margin: 0px 1px; vertical-align: middle;\">表情又好了。。。</p>', 1545281662, 0);
INSERT INTO `ws_dynamicMsg` VALUES (32, 6, 22, '<p>你看到了吗？</p>', 1545281688, 0);
INSERT INTO `ws_dynamicMsg` VALUES (33, 2, 22, '<p><span style=\"width: 41px; display: none;\">&nbsp;</span><span>&nbsp;看到了</span></p>', 1545281710, 6);
INSERT INTO `ws_dynamicMsg` VALUES (34, 3, 22, '<p><span style=\"width: 36px; display: none;\">&nbsp;</span><span>&nbsp;我也看到了</span></p>', 1545282810, 2);
INSERT INTO `ws_dynamicMsg` VALUES (35, 2, 36, '<p>行吧<img src=\"./static/img/fFace/fFace_01.png\" alt=\"face\" data-w-e=\"1\"></p>', 1546867009, 0);
INSERT INTO `ws_dynamicMsg` VALUES (36, 6, 38, '<p>你就是枣子哥？</p>', 1548835839, 0);
INSERT INTO `ws_dynamicMsg` VALUES (37, 6, 22, '<p><span style=\"width: 58px; display: none;\">&nbsp;</span><span> 又有问题了。。。</span></p>', 1549872563, 2);
INSERT INTO `ws_dynamicMsg` VALUES (38, 6, 22, '<p><span style=\"width: 58px; display: none;\">&nbsp;</span><span> </span>好起来了~</p>', 1549872807, 2);
INSERT INTO `ws_dynamicMsg` VALUES (39, 6, 38, '<p><span style=\"width: 41px; display: none;\">&nbsp;</span><span> 怎么不说话？<br></span></p>', 1549873036, 6);
INSERT INTO `ws_dynamicMsg` VALUES (40, 6, 38, '<p><span style=\"width: 41px; display: none;\">&nbsp;</span><span> 123</span></p>', 1549873057, 6);
INSERT INTO `ws_dynamicMsg` VALUES (41, 6, 22, '<p><span style=\"width: 58px; display: none;\">&nbsp;</span><span> 777</span></p>', 1549873113, 2);
INSERT INTO `ws_dynamicMsg` VALUES (42, 6, 36, '<p><span style=\"width: 58px; display: none;\">&nbsp;</span><span> 做完了<img src=\"./static/img/fFace/fFace_03.png\" alt=\"face\" data-w-e=\"1\"></span></p>', 1553092565, 2);

-- ----------------------------
-- Table structure for ws_friendMsg
-- ----------------------------
DROP TABLE IF EXISTS `ws_friendMsg`;
CREATE TABLE `ws_friendMsg`  (
  `friendMsg_id` int(11) NOT NULL AUTO_INCREMENT,
  `from_user` int(11) NOT NULL,
  `to_user` int(11) NOT NULL,
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `write_date` int(11) NOT NULL,
  `is_check` int(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`friendMsg_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 93 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of ws_friendMsg
-- ----------------------------
INSERT INTO `ws_friendMsg` VALUES (31, 2, 6, '<p>你好！</p><p>123<br></p>', 1544259451, 0);
INSERT INTO `ws_friendMsg` VALUES (32, 3, 6, '<p>321<img src=\"./static/img/fFace/fFace_01.png\" alt=\"face\" data-w-e=\"1\"><img src=\"./static/img/fFace/fFace_01.png\" alt=\"face\" data-w-e=\"1\"><img src=\"./static/img/fFace/fFace_01.png\" alt=\"face\"></p>', 1544259674, 0);
INSERT INTO `ws_friendMsg` VALUES (33, 2, 6, '<p>在吗？</p>', 1547190076, 0);
INSERT INTO `ws_friendMsg` VALUES (34, 6, 3, '<p>你也太可爱了吧！</p>', 1548658995, 0);
INSERT INTO `ws_friendMsg` VALUES (35, 3, 6, '<p>你就是个弟弟。</p>', 1548659000, 0);
INSERT INTO `ws_friendMsg` VALUES (36, 6, 3, '<p>你说是就是把~</p>', 1548659001, 0);
INSERT INTO `ws_friendMsg` VALUES (37, 3, 6, '<a href=\"static/img/test-1.jpg\" target=\"_blank\" class=\"img\"><img src=\"static/img/test-1.jpg\" alt=\"\"></a>', 1548659008, 0);
INSERT INTO `ws_friendMsg` VALUES (38, 6, 2, '<p>在的！</p>', 1549699242, 0);
INSERT INTO `ws_friendMsg` VALUES (39, 6, 2, '<p>有什么事吗？</p>', 1549700445, 0);
INSERT INTO `ws_friendMsg` VALUES (40, 2, 6, '<p>gck</p>', 1549700555, 0);
INSERT INTO `ws_friendMsg` VALUES (41, 6, 2, '<p>???</p>', 1549700854, 0);
INSERT INTO `ws_friendMsg` VALUES (42, 6, 2, '<p>你是傻逼吧<img src=\"./static/img/fFace/fFace_15.png\" alt=\"face\" data-w-e=\"1\"></p>', 1549700909, 0);
INSERT INTO `ws_friendMsg` VALUES (43, 2, 6, '<p><img src=\"./static/img/fFace/fFace_03.png\" alt=\"face\" data-w-e=\"1\"><br></p>', 1549701437, 0);
INSERT INTO `ws_friendMsg` VALUES (44, 2, 6, '<p>今天是个好日子~</p><p><img src=\"./static/img/fFace/fFace_02.png\" alt=\"face\" data-w-e=\"1\"><br></p>', 1549701800, 0);
INSERT INTO `ws_friendMsg` VALUES (45, 6, 2, '<p>彳亍口吧</p>', 1549702299, 0);
INSERT INTO `ws_friendMsg` VALUES (46, 6, 2, '<p>777</p>', 1549702375, 0);
INSERT INTO `ws_friendMsg` VALUES (47, 2, 6, '<p>阿三地方都是</p>', 1549702428, 0);
INSERT INTO `ws_friendMsg` VALUES (48, 2, 6, '<p>897451237</p>', 1549702515, 0);
INSERT INTO `ws_friendMsg` VALUES (49, 2, 6, '<p>784512</p>', 1549702568, 0);
INSERT INTO `ws_friendMsg` VALUES (50, 2, 6, '<p>¿</p>', 1549702675, 0);
INSERT INTO `ws_friendMsg` VALUES (51, 6, 2, '<p>这个问号怎么反向的？</p>', 1549702986, 0);
INSERT INTO `ws_friendMsg` VALUES (52, 6, 2, '<a href=\"http://www.test3.com/wsChat/resources/6_1549704098_0.jpg\" target=\"_blank\" class=\"img\"><img src=\"http://www.test3.com/wsChat/resources/6_1549704098_0.jpg\" alt=\"[图片]\"></a>', 1549704098, 0);
INSERT INTO `ws_friendMsg` VALUES (53, 2, 6, '<p>sb</p>', 1549704157, 0);
INSERT INTO `ws_friendMsg` VALUES (54, 2, 6, '<a href=\"http://www.test3.com/wsChat/resources/2_1549704231_0.jpg\" target=\"_blank\" class=\"img\"><img src=\"http://www.test3.com/wsChat/resources/2_1549704231_0.jpg\" alt=\"[图片]\"></a>', 1549704231, 0);
INSERT INTO `ws_friendMsg` VALUES (55, 6, 2, '<p>\n11.删除群成员做了，但是删除完成后通知没做，要记得\n\n</p>', 1549870623, 0);
INSERT INTO `ws_friendMsg` VALUES (56, 6, 2, '<p>怎么发错了。。。</p>', 1549870899, 0);
INSERT INTO `ws_friendMsg` VALUES (57, 2, 6, '<p>在吗？</p>', 1549963022, 0);
INSERT INTO `ws_friendMsg` VALUES (58, 9, 6, '<p>咋回事</p>', 1550044376, 0);
INSERT INTO `ws_friendMsg` VALUES (59, 9, 6, '<p>你是我的朋友吗？</p>', 1550044640, 0);
INSERT INTO `ws_friendMsg` VALUES (60, 9, 6, '<a href=\"http://www.test3.com/wsChat/resources/9_1550047679_0.jpg\" target=\"_blank\" class=\"img\"><img src=\"http://www.test3.com/wsChat/resources/9_1550047679_0.jpg\" alt=\"[图片]\"></a>', 1550047679, 0);
INSERT INTO `ws_friendMsg` VALUES (61, 6, 9, '你好', 1550069037, 0);
INSERT INTO `ws_friendMsg` VALUES (62, 6, 9, '<p>完善添加、删除</p>', 1550071916, 0);
INSERT INTO `ws_friendMsg` VALUES (63, 6, 9, '<p>分页</p>', 1550071920, 0);
INSERT INTO `ws_friendMsg` VALUES (64, 9, 6, '<p>看看还有什么要做的</p>', 1550151303, 0);
INSERT INTO `ws_friendMsg` VALUES (65, 9, 6, '<p>假期快结束了。。。</p>', 1550242353, 0);
INSERT INTO `ws_friendMsg` VALUES (66, 9, 6, '<p>啊！！！！！！！</p>', 1550242370, 0);
INSERT INTO `ws_friendMsg` VALUES (67, 6, 9, '<p>dd</p>', 1550243359, 0);
INSERT INTO `ws_friendMsg` VALUES (68, 6, 9, '<p>777</p>', 1550243373, 0);
INSERT INTO `ws_friendMsg` VALUES (69, 6, 9, '<p>????</p>', 1550243478, 0);
INSERT INTO `ws_friendMsg` VALUES (70, 9, 6, '<p>头疼了</p>', 1550243546, 0);
INSERT INTO `ws_friendMsg` VALUES (71, 9, 6, '<p>什么鬼</p>', 1550243567, 0);
INSERT INTO `ws_friendMsg` VALUES (72, 9, 6, '<p>这是搞笑吗？</p>', 1550243757, 0);
INSERT INTO `ws_friendMsg` VALUES (73, 6, 9, '<p></p><p><br></p>', 1550244014, 0);
INSERT INTO `ws_friendMsg` VALUES (74, 6, 9, '<p>第一天</p>', 1550478401, 0);
INSERT INTO `ws_friendMsg` VALUES (75, 9, 6, '<p>看到我说话吗？</p>', 1552125524, 0);
INSERT INTO `ws_friendMsg` VALUES (76, 9, 6, '<p>还看到吗？</p>', 1552126804, 0);
INSERT INTO `ws_friendMsg` VALUES (77, 9, 6, '<p>321321</p>', 1552127727, 0);
INSERT INTO `ws_friendMsg` VALUES (78, 9, 6, '<p>QAQ</p>', 1552127930, 0);
INSERT INTO `ws_friendMsg` VALUES (81, 9, 6, '<p>这下看不到了吧~</p>', 1552132589, 0);
INSERT INTO `ws_friendMsg` VALUES (82, 2, 6, '<p><img src=\"./static/img/fFace/fFace_01.png\" alt=\"face\" data-w-e=\"1\"><br></p>', 1552391619, 0);
INSERT INTO `ws_friendMsg` VALUES (83, 2, 6, '<p><img src=\"./static/img/fFace/fFace_05.png\" alt=\"face\" data-w-e=\"1\"><br></p>', 1552391639, 0);
INSERT INTO `ws_friendMsg` VALUES (84, 6, 2, '<p>~</p>', 1552391880, 0);
INSERT INTO `ws_friendMsg` VALUES (85, 6, 2, '<p>ok了</p>', 1552392343, 0);
INSERT INTO `ws_friendMsg` VALUES (86, 6, 2, '<p><img src=\"./static/img/fFace/fFace_06.png\" alt=\"face\" data-w-e=\"1\"></p>', 1552392388, 0);
INSERT INTO `ws_friendMsg` VALUES (87, 6, 2, '?<p></p>', 1552392457, 0);
INSERT INTO `ws_friendMsg` VALUES (88, 2, 6, '<a href=\"http://ws.alcyh.com/resources/2_1552392520_0.jpg\" target=\"_blank\" class=\"img\"><img src=\"http://ws.alcyh.com/resources/2_1552392520_0.jpg\" alt=\"[图片]\"></a>', 1552392520, 0);
INSERT INTO `ws_friendMsg` VALUES (89, 6, 2, '<p>我晕了</p>', 1552392672, 0);
INSERT INTO `ws_friendMsg` VALUES (90, 2, 6, '<p>晕了就好</p>', 1552392701, 0);
INSERT INTO `ws_friendMsg` VALUES (91, 6, 2, '<p>NM$L？</p>', 1552392838, 0);
INSERT INTO `ws_friendMsg` VALUES (92, 6, 3, '<p>你好123<img src=\"./static/img/fFace/fFace_01.png\" alt=\"face\" data-w-e=\"1\"></p>', 1553007923, 0);

-- ----------------------------
-- Table structure for ws_group
-- ----------------------------
DROP TABLE IF EXISTS `ws_group`;
CREATE TABLE `ws_group`  (
  `group_id` int(11) NOT NULL AUTO_INCREMENT,
  `group_account` int(11) NOT NULL,
  `group_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `info` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `headPath` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`group_id`) USING BTREE,
  UNIQUE INDEX `group_account`(`group_account`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of ws_group
-- ----------------------------
INSERT INTO `ws_group` VALUES (1, 431697, '弱智交流群', 6, '拥护党的纲领,遵守党的章程,履行党员义务,执行党的决定,严守党的纪律,保守党的秘密.', 'http://www.test3.com/wsChat/resources/1549181319.jpg');
INSERT INTO `ws_group` VALUES (4, 429997, '牛魔王粉丝群', 6, '守护世上最好的牛牛~', 'http://www.test3.com/wsChat/resources/1550241424.jpg');

-- ----------------------------
-- Table structure for ws_groupMsg
-- ----------------------------
DROP TABLE IF EXISTS `ws_groupMsg`;
CREATE TABLE `ws_groupMsg`  (
  `groupMsg_id` int(11) NOT NULL AUTO_INCREMENT,
  `from_user` int(11) NOT NULL,
  `to_group` int(11) NOT NULL,
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `write_date` int(11) NOT NULL,
  `is_check` int(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`groupMsg_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 71 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of ws_groupMsg
-- ----------------------------
INSERT INTO `ws_groupMsg` VALUES (1, 2, 1, '<p>有人吗？</p><p>777<br></p>', 1544259539, 0);
INSERT INTO `ws_groupMsg` VALUES (2, 6, 1, '<p>有啊，干什么？</p>', 1549586175, 0);
INSERT INTO `ws_groupMsg` VALUES (3, 3, 1, '<a href=\"http://www.test3.com/wsChat/resources/1549178295.jpg\" target=\"_blank\" class=\"img\"><img src=\"http://www.test3.com/wsChat/resources/1549178295.jpg\" alt=\"\"></a>', 1549586180, 0);
INSERT INTO `ws_groupMsg` VALUES (4, 9, 1, '<p><img src=\"./static/img/fFace/fFace_08.png\" alt=\"face\"></p>', 1549699758, 0);
INSERT INTO `ws_groupMsg` VALUES (5, 6, 1, '<p>???</p>', 1549723083, 0);
INSERT INTO `ws_groupMsg` VALUES (6, 6, 1, '<p>!!!!!</p>', 1549723383, 0);
INSERT INTO `ws_groupMsg` VALUES (7, 6, 1, '<p>。。。</p>', 1549723444, 0);
INSERT INTO `ws_groupMsg` VALUES (8, 6, 1, '<p><img src=\"./static/img/fFace/fFace_05.png\" alt=\"face\" data-w-e=\"1\"></p>', 1549723451, 0);
INSERT INTO `ws_groupMsg` VALUES (9, 2, 1, '<p>你好，群主~</p>', 1549723869, 0);
INSERT INTO `ws_groupMsg` VALUES (10, 6, 1, '<p>你好，脑残一号~</p>', 1549723942, 0);
INSERT INTO `ws_groupMsg` VALUES (11, 6, 1, '<p>？？？？</p>', 1549723962, 0);
INSERT INTO `ws_groupMsg` VALUES (12, 6, 1, '<p>什么情况？？</p>', 1549724000, 0);
INSERT INTO `ws_groupMsg` VALUES (13, 2, 1, '<p>不知道啊。。。</p>', 1549724313, 0);
INSERT INTO `ws_groupMsg` VALUES (14, 2, 1, '<p>应该可以了</p>', 1549724510, 0);
INSERT INTO `ws_groupMsg` VALUES (15, 2, 1, '<p>~</p>', 1549724525, 0);
INSERT INTO `ws_groupMsg` VALUES (16, 6, 1, '<p>数据库的问题还没有解决啊。。。</p>', 1549724658, 0);
INSERT INTO `ws_groupMsg` VALUES (17, 6, 1, '<p>头疼</p>', 1549724730, 0);
INSERT INTO `ws_groupMsg` VALUES (18, 2, 1, '<p>11111</p>', 1549724910, 0);
INSERT INTO `ws_groupMsg` VALUES (19, 6, 1, '<p>啊手动阀手动阀</p>', 1549725206, 0);
INSERT INTO `ws_groupMsg` VALUES (20, 6, 1, '<p>救命啊！</p>', 1549725268, 0);
INSERT INTO `ws_groupMsg` VALUES (21, 6, 1, '<p>我是群主。。</p>', 1549725284, 0);
INSERT INTO `ws_groupMsg` VALUES (22, 6, 1, '<p><img src=\"./static/img/fFace/fFace_09.png\" alt=\"face\" data-w-e=\"1\"></p>', 1549725308, 0);
INSERT INTO `ws_groupMsg` VALUES (23, 2, 1, '<p>别哭</p>', 1549725375, 0);
INSERT INTO `ws_groupMsg` VALUES (24, 6, 1, '<p>奇怪了</p>', 1549725437, 0);
INSERT INTO `ws_groupMsg` VALUES (25, 2, 1, '<p>我这边就是好好的</p>', 1549725486, 0);
INSERT INTO `ws_groupMsg` VALUES (26, 6, 1, '<p>。。。</p>', 1549725524, 0);
INSERT INTO `ws_groupMsg` VALUES (27, 6, 1, '<p><img src=\"./static/img/fFace/fFace_10.png\" alt=\"face\" data-w-e=\"1\" style=\"width: 18px; height: 18px; margin: 0px 1px; vertical-align: middle;\">尴尬</p>', 1549725545, 0);
INSERT INTO `ws_groupMsg` VALUES (28, 6, 1, '<a href=\"http://www.test3.com/wsChat/resources/6_1549725641_0.jpg\" target=\"_blank\" class=\"img\"><img src=\"http://www.test3.com/wsChat/resources/6_1549725641_0.jpg\" alt=\"[图片]\"></a>', 1549725642, 0);
INSERT INTO `ws_groupMsg` VALUES (29, 2, 1, '<a href=\"http://www.test3.com/wsChat/resources/2_1549725662_0.png\" target=\"_blank\" class=\"img\"><img src=\"http://www.test3.com/wsChat/resources/2_1549725662_0.png\" alt=\"[图片]\"></a>', 1549725662, 0);
INSERT INTO `ws_groupMsg` VALUES (30, 6, 1, '<p>剩余问题</p><p>1.数据库到一定时间不能连接。</p><p>2.添加、删除好友群成员。</p><p>3.聊天记录、动态的分页。</p><p>4.编辑框的换行问题。</p><p>5.背景。<br></p>', 1549725824, 0);
INSERT INTO `ws_groupMsg` VALUES (31, 6, 1, '<p>6.声音提示。</p>', 1549726000, 0);
INSERT INTO `ws_groupMsg` VALUES (32, 6, 1, '<p>7.\n按ctrl+Enter发送。</p>', 1549726018, 0);
INSERT INTO `ws_groupMsg` VALUES (33, 6, 1, '<p>8.联系人页面里面的好友和群聊还没做跳转。</p>', 1549726089, 0);
INSERT INTO `ws_groupMsg` VALUES (34, 6, 1, '<p>9.黑名单。</p>', 1549726134, 0);
INSERT INTO `ws_groupMsg` VALUES (35, 6, 1, '<p>10.动态页面只看自己的按钮还没做。</p>', 1549726183, 0);
INSERT INTO `ws_groupMsg` VALUES (36, 2, 1, '<p>总结</p><p>先完成：2 3 8 9 10</p><p>其它先放放</p>', 1549726325, 0);
INSERT INTO `ws_groupMsg` VALUES (37, 9, 1, '<p>8完成</p>', 1549860671, 0);
INSERT INTO `ws_groupMsg` VALUES (38, 6, 1, '<p>11.删除群成员做了，但是删除完成后通知没做，要记得</p>', 1549870597, 0);
INSERT INTO `ws_groupMsg` VALUES (39, 6, 1, '<p>???</p>', 1549870794, 0);
INSERT INTO `ws_groupMsg` VALUES (40, 6, 1, '<p>11.还有群的活跃时间也没做</p>', 1549870971, 0);
INSERT INTO `ws_groupMsg` VALUES (41, 6, 1, '<p>申请加入</p>', 1549899011, 0);
INSERT INTO `ws_groupMsg` VALUES (42, 6, 1, '<p><img src=\"./static/img/fFace/fFace_09.png\" alt=\"face\" data-w-e=\"1\"></p>', 1549961806, 0);
INSERT INTO `ws_groupMsg` VALUES (43, 6, 1, '<p>以后一定要想清楚了再做。。。</p>', 1549962164, 0);
INSERT INTO `ws_groupMsg` VALUES (44, 6, 1, '<p>886</p>', 1549962282, 0);
INSERT INTO `ws_groupMsg` VALUES (45, 2, 1, '<p>看来你是个sb</p>', 1549963057, 0);
INSERT INTO `ws_groupMsg` VALUES (46, 2, 1, '<p>777</p>', 1549963257, 0);
INSERT INTO `ws_groupMsg` VALUES (47, 2, 1, '<p>14</p>', 1549963387, 0);
INSERT INTO `ws_groupMsg` VALUES (48, 2, 1, '<p>成功</p>', 1549963974, 0);
INSERT INTO `ws_groupMsg` VALUES (49, 6, 1, '<p>申请加群记录的删除和审核</p>', 1549964081, 0);
INSERT INTO `ws_groupMsg` VALUES (50, 6, 1, '<p></p>有点问题。。<br>', 1549964122, 0);
INSERT INTO `ws_groupMsg` VALUES (51, 2, 1, '<p>请给我惊喜</p>', 1549964160, 0);
INSERT INTO `ws_groupMsg` VALUES (52, 6, 1, '<p>我可以说话吗？</p>', 1549964176, 0);
INSERT INTO `ws_groupMsg` VALUES (53, 6, 1, '<p>糟糕的假期</p>', 1549979195, 0);
INSERT INTO `ws_groupMsg` VALUES (54, 6, 1, '<p>欢迎新朋友~</p>', 1549980087, 0);
INSERT INTO `ws_groupMsg` VALUES (55, 6, 1, '<p>我晕了</p>', 1549986061, 0);
INSERT INTO `ws_groupMsg` VALUES (56, 9, 1, '<p>我也是</p>', 1549986505, 0);
INSERT INTO `ws_groupMsg` VALUES (57, 9, 1, '<p><img src=\"./static/img/fFace/fFace_09.png\" alt=\"face\" data-w-e=\"1\"><br></p>', 1549986721, 0);
INSERT INTO `ws_groupMsg` VALUES (58, 6, 1, '<p>拉人进群和好友的申请、删除还没做</p>', 1549986776, 0);
INSERT INTO `ws_groupMsg` VALUES (59, 9, 1, '<p>活跃一下</p>', 1550067332, 0);
INSERT INTO `ws_groupMsg` VALUES (60, 9, 1, '<p>还有创建群聊没做。。</p>', 1550151366, 0);
INSERT INTO `ws_groupMsg` VALUES (61, 9, 1, '<p>？？</p>', 1550151401, 0);
INSERT INTO `ws_groupMsg` VALUES (62, 9, 1, '<p>777</p>', 1550151529, 0);
INSERT INTO `ws_groupMsg` VALUES (63, 6, 1, '<p>这样就不会重复了~<img src=\"./static/img/fFace/fFace_03.png\" alt=\"face\" data-w-e=\"1\"></p>', 1550151832, 0);
INSERT INTO `ws_groupMsg` VALUES (64, 6, 1, '<p>\n明天完成创建群聊、动态只看自己、声音，有空研究换行、\nctrl+Ente，背景不重要了，今天累了也懒了~</p>', 1550152020, 0);
INSERT INTO `ws_groupMsg` VALUES (65, 6, 1, '<p>ctrl+enter是个问题</p>', 1550243774, 0);
INSERT INTO `ws_groupMsg` VALUES (66, 6, 1, '<br>要解决<p></p>', 1550243792, 0);
INSERT INTO `ws_groupMsg` VALUES (67, 6, 1, '<br><br>？<p></p>', 1550243801, 0);
INSERT INTO `ws_groupMsg` VALUES (68, 6, 1, '<p>士大夫撒地方</p>', 1550243819, 0);
INSERT INTO `ws_groupMsg` VALUES (69, 6, 1, '<p>\n换行、\nctrl+Ente改成是否保存登录记录、背景、聊天记录后台分页\n\n</p>', 1550244562, 0);
INSERT INTO `ws_groupMsg` VALUES (70, 3, 1, '<p>现在是2019年3月25日16点06分<img src=\"./static/img/fFace/fFace_22.png\" alt=\"face\" data-w-e=\"1\" style=\"background-color: rgb(255, 255, 255); width: 18px; height: 18px; margin: 0px 1px; vertical-align: middle;\"></p>', 1553501225, 0);

-- ----------------------------
-- Table structure for ws_record
-- ----------------------------
DROP TABLE IF EXISTS `ws_record`;
CREATE TABLE `ws_record`  (
  `record_id` int(11) NOT NULL AUTO_INCREMENT,
  `self_id` int(11) NOT NULL,
  `target_id` int(11) NOT NULL,
  `tb_type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `tb_id` int(11) NOT NULL,
  `is_check` int(1) NOT NULL DEFAULT 0,
  `sort` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`record_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of ws_record
-- ----------------------------
INSERT INTO `ws_record` VALUES (1, 2, 6, 'friendMsg', 91, 1, 0);
INSERT INTO `ws_record` VALUES (2, 3, 6, 'friendMsg', 92, 0, 0);
INSERT INTO `ws_record` VALUES (3, 2, 1, 'groupMsg', 70, 0, 0);
INSERT INTO `ws_record` VALUES (5, 6, 3, 'friendMsg', 92, 1, 0);
INSERT INTO `ws_record` VALUES (7, 6, 2, 'friendMsg', 91, 1, 0);
INSERT INTO `ws_record` VALUES (9, 3, 1, 'groupMsg', 70, 0, 0);
INSERT INTO `ws_record` VALUES (10, 6, 1, 'groupMsg', 70, 1, 0);
INSERT INTO `ws_record` VALUES (15, 9, 6, 'friendMsg', 81, 1, 0);
INSERT INTO `ws_record` VALUES (16, 6, 9, 'friendMsg', 78, 1, 0);
INSERT INTO `ws_record` VALUES (18, 9, 1, 'groupMsg', 70, 0, 0);

-- ----------------------------
-- Table structure for ws_relation
-- ----------------------------
DROP TABLE IF EXISTS `ws_relation`;
CREATE TABLE `ws_relation`  (
  `relation_id` int(11) NOT NULL AUTO_INCREMENT,
  `creater_id` int(11) NOT NULL,
  `target_id` int(11) NOT NULL,
  `nickName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `is_ban` int(1) NOT NULL DEFAULT 0,
  `write_date` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`relation_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 41 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of ws_relation
-- ----------------------------
INSERT INTO `ws_relation` VALUES (1, 2, 6, '', 0, 0);
INSERT INTO `ws_relation` VALUES (2, 6, 2, '小良', 0, 0);
INSERT INTO `ws_relation` VALUES (3, 2, 3, '', 1, 0);
INSERT INTO `ws_relation` VALUES (4, 3, 2, '', 0, 0);
INSERT INTO `ws_relation` VALUES (5, 3, 6, '', 0, 0);
INSERT INTO `ws_relation` VALUES (6, 6, 3, '可望不可及', 0, 0);
INSERT INTO `ws_relation` VALUES (39, 6, 9, '', 1, 1552129405);
INSERT INTO `ws_relation` VALUES (40, 9, 6, '', 0, 0);

-- ----------------------------
-- Table structure for ws_user
-- ----------------------------
DROP TABLE IF EXISTS `ws_user`;
CREATE TABLE `ws_user`  (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_account` int(11) NOT NULL,
  `user_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `password` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `sex` int(1) UNSIGNED NOT NULL DEFAULT 0,
  `sexName` varchar(4) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '无',
  `sign` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `headPath` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `area` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `areaArray` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `email` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `loginKey` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `status` int(1) NOT NULL DEFAULT 0,
  `hasNewDynamic` int(1) NOT NULL DEFAULT 0,
  `hasNewDynamicMsg` int(1) NOT NULL DEFAULT 0,
  `age` int(3) UNSIGNED NULL DEFAULT 0,
  `bgImgUrls` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  PRIMARY KEY (`user_id`) USING BTREE,
  UNIQUE INDEX `user_account`(`user_account`) USING BTREE,
  UNIQUE INDEX `email`(`email`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of ws_user
-- ----------------------------
INSERT INTO `ws_user` VALUES (2, 546542312, 'xl', '47789.321', 0, '无', '明天会更好~', 'http://www.test3.com/wsChat/resources/1548657410.jpg', '', '', '2281588099@qq.com', '', '4c7b7d8107d742ada60fa6c454ea0280', 1, 0, 0, 0, NULL);
INSERT INTO `ws_user` VALUES (3, 598432145, 'cyh', '47789.321', 0, '无', '拥护党的纲领,遵守党的章程,履行党员义务,执行党的决定,严守党的纪律,保守党的秘密.', 'http://www.test3.com/wsChat/resources/1548657487.jpg', '', '', 'cyh@qq.com', '', 'e9a22ca335a8f9b06d2a0da62b7d00fd', 1, 0, 0, 0, NULL);
INSERT INTO `ws_user` VALUES (6, 529055786, 'fzl', '47789.321', 1, '男', '我也能找到吗？在仅有一次的生命里。', 'http://www.test3.com/wsChat/resources/1549178295.jpg', '广东省 广州市 南沙区', '[\"44\",\"4401\",\"440115\"]', '505911050@qq.com', '13128269543', '85e12e7839f864e4c62294d25e58abb0', 1, 0, 0, 22, 'http://ws.alcyh.com/resources/6_1551775042_0.jpg,http://ws.alcyh.com/resources/6_1551775186_0.png');
INSERT INTO `ws_user` VALUES (9, 562314794, 'xxl', '47789.321', 0, '无', NULL, './static/img/user-head.png', NULL, NULL, 'xxl@qq.com', NULL, 'c8793caf6a330a66994b384d8cf5a455', 1, 0, 0, 0, 'http://ws.alcyh.com/resources/9_1552129076_0.jpg');

SET FOREIGN_KEY_CHECKS = 1;
