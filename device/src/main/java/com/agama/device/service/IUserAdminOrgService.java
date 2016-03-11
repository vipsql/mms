package com.agama.device.service;

import java.util.List;

import com.agama.authority.entity.User;
import com.agama.common.service.IBaseService;
import com.agama.device.domain.UserAdminOrg;

/**
 * @Description:内部用户管理的机构Service接口
 * @Author:scuta
 * @Since :2015年8月27日 上午10:42:55
 */
public interface IUserAdminOrgService extends IBaseService<UserAdminOrg, Integer> {

	/**
	 * 添加修改用户机构
	 * 
	 * @param id
	 * @param oldList
	 * @param newList
	 */
	public void updateUserOrg(Integer userId,List<Integer> oldList, List<Integer> newList) ;

	/**
	 * 获取用户拥有机构id集合
	 * 
	 * @param userId
	 * @return 结果集合
	 */
	public List<Integer> getOrgIdList(Integer userId) ;
	
	public List<User> getUserListByOrgId(Integer orgId);

}
