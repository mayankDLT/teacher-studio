=begin 
  results_controller.rb
  Description: Controller file for managing results of exams
  Created on: March 05, 2011
  Last modified on: March 18, 2013
  Copyright 2013 PIT Solutions Pvt. Ltd. All Rights Reserved.
=end

class ResultsController < ApplicationController
  filter_access_to :all
  
  def index
    @organization_id = Setting.find(:first).organization_id
    @currentUser = User.find_by_id(current_user.id)
    @categories = @currentUser.categories
    @categoryId = params[:categoryId].to_i
    @examType = params[:et_name].to_i
    @year = params[:academicYear].to_i
    
    @examTypes = Examtype.where(['organization_id = ?',@organization_id])
    @yrs = Array.new(10){|i| Date.current.year-i}
    unless @categories.empty?
    @category_user = Categoryuser.find(:all, :joins=> "INNER JOIN categories ON categories.id = categoryusers.category_id  AND categoryusers.user_id = #{@currentUser.id} AND categories.organization_id = #{@organization_id}")
    end
    if current_user.role_id == Examinee      
      unless @categoryId == 0
        user = current_user.id

        sql = "SELECT E.categoryexam_id,E.categoryuser_id,E.examname,E.attempt,E.total_mark,E.score,E.percent,E.status,E.result_pending
        From exam_results E
        Inner Join categoryexams C on E.categoryexam_id = C.id
        Inner Join categoryusers D on E.categoryuser_id = D.id
        Inner Join categories F on C.category_id = F.id
        Inner Join exams S on C.exam_id = S.id
        Inner Join examtypes T on C.examtype_id = T.id
        Inner Join users U on D.user_id = U.id
    
        where U.id = #{@currentUser.id} and F.id = #{@categoryId} and T.id = #{@examType} and C.currentyear = #{@year}
        Group By F.id,S.id,S.name,E.attempt,S.total_mark;"
        
        @results = Evaluation.find_by_sql(sql)
      else
        user = current_user.id
        sql = "SELECT E.categoryexam_id,E.categoryuser_id,E.examname,E.attempt,E.total_mark,E.score,E.percent,E.status,E.result_pending
        From exam_results E
        Inner Join categoryexams C on E.categoryexam_id = C.id
        Inner Join categoryusers D on E.categoryuser_id = D.id
        Inner Join categories F on C.category_id = F.id
        Inner Join exams S on C.exam_id = S.id
        Inner Join users U on D.user_id = U.id
    
        where U.id = #{@currentUser.id} 
        Group By F.id,S.id,S.name,E.attempt,S.total_mark;"
        
        @results = Evaluation.find_by_sql(sql)
      end
    end
  end

  def usersResult
    @c = Category.where(['organization_id = ?',@organization_id])
    @category_id = params[:examCategory].to_i
    @yrs = Array.new(10){|i| Date.current.year-i}
    @examTypes = Examtype.where(['organization_id = ?',@organization_id])
     category_id = params[:examCategory].to_i
     academicYear = params[:academicYear].to_i
     @academicYear = params[:academicYear].to_i
     examtype = params[:examtype].to_i
     @examtype = params[:examtype].to_i
    unless @category_id == 0
      sql = "SELECT  distinct U.Name,U.login,U.is_temp_examinee as tempexaminee, U.id as user_id, D.category_id as categoryid, D.currentyear as academicyear, C.examtype_id as examtype 
          FROM       categoryexamusers Q 
          Inner Join categoryusers D on Q.categoryuser_id = D.id
          Inner Join categoryexams C on Q.categoryexam_id = C.id
          Inner Join users U on D.user_id = U.id
          where C.category_id= #{category_id}    and D.currentyear = #{academicYear} and C.examtype_id = #{examtype};" 
          @category_user = Categoryuser.find_by_sql(sql)
    end 
  end

 def viewUserResult

     user = params[:user_id].to_i
     category_id = params[:category_id].to_i
     academicYear = params[:academicyear].to_i
     examtype = params[:examtype].to_i
 
      sql = "SELECT E.examname,C.id as categoryexamId,C.examtype_id as examType, D.id as categoryuserId,U.name as username,Q.attempt,E.total_mark,E.score,E.percent,E.status,E.result_pending
      From exam_results E
      Inner Join categoryexamusers Q on E.categoryuser_id = Q.categoryuser_id
      AND  E.categoryexam_id = Q.categoryexam_id AND E.attempt = Q.attempt
      Inner Join categoryexams C on E.categoryexam_id = C.id
      Inner Join categoryusers D on E.categoryuser_id = D.id
      Inner Join categories F on C.category_id = F.id
      Inner Join exams S on C.exam_id = S.id
      Inner Join users U on D.user_id = U.id
      Inner Join examtypes Y on C.examtype_id = Y.id

      where U.id = #{user} and C.category_id= #{category_id}  and C.currentyear = #{academicYear}  and C.examtype_id = #{examtype}
      Group By C.id;"
      
      @attended_results = Evaluation.find_by_sql(sql)
      
      @exam_completed_ids = Array.new
      unless @attended_results.blank?
        @attended_results.each do |attended_result|
          @exam_completed_ids << attended_result.categoryexamId
        end
      end

      not_attended_sql = "SELECT E.id,E.name, CEU.attempt, E.total_mark, CEU.has_attended as attendance, CE.id as categoryexamId, CE.examtype_id as examType, CU.id as categoryuserId, U.name as username
      FROM exams E
      Inner Join categoryexams CE on E.id = CE.exam_id
      Inner Join categoryexamusers CEU on CE.id = CEU.categoryexam_id
      Inner Join categoryusers CU on CEU.categoryuser_id = CU.id
      Inner Join categories C on CE.category_id = C.id
      Inner Join users U on CU.user_id = U.id
      Inner Join examtypes ET on CE.examtype_id = ET.id
      WHERE CE.category_id = #{category_id} AND CEU.has_attended = 0 AND U.id = #{user} AND CE.currentyear = #{academicYear} AND CE.examtype_id = #{examtype}
      Group By CE.id;"
     
      @not_attended_results = Exam.find_by_sql(not_attended_sql)

      @temp = @exam_completed_ids.dup
      not_completed_sql = "SELECT E.id,E.name, CEU.attempt, E.total_mark, CEU.has_attended as attendance, CE.id as categoryexamId, CE.examtype_id as examType, CU.id as categoryuserId, U.name as username

      FROM exams E
      Inner Join categoryexams CE on E.id = CE.exam_id
      Inner Join categoryexamusers CEU on CE.id = CEU.categoryexam_id
      Inner Join categoryusers CU on CEU.categoryuser_id = CU.id
      Inner Join categories C on CE.category_id = C.id
      Inner Join users U on CU.user_id = U.id
      Inner Join examtypes ET on CE.examtype_id = ET.id
      WHERE CE.category_id = #{category_id} AND CEU.has_attended = 1 AND U.id = #{user} AND CE.currentyear = #{academicYear} AND CE.examtype_id = #{examtype}" + (@temp.blank? ? "" : " AND CEU.categoryexam_id NOT IN (#{@temp.join(',')})") +
      " Group By CE.id;"

      @not_completed_results = Exam.find_by_sql(not_completed_sql)
      
      @combine_results = TwoDimArray.new
      i = 0
      unless @attended_results.blank?
        @attended_results.each do |attended_result|
          @combine_results[i][0] = attended_result.categoryexamId
          @combine_results[i][1] = attended_result.examname
          @combine_results[i][2] = attended_result.examType
          @combine_results[i][3] = attended_result.categoryuserId
          @combine_results[i][4] = attended_result.username
          @combine_results[i][5] = attended_result.attempt
          @combine_results[i][6] = attended_result.total_mark
          @combine_results[i][7] = attended_result.score
          @combine_results[i][8] = attended_result.percent
          @combine_results[i][9] = attended_result.status
          @combine_results[i][10] = attended_result.result_pending
          @combine_results[i][11] = 1 #has_attended status has been set to 1
          i += 1
        end
      end
      unless @not_attended_results.blank?
        @not_attended_results.each do |not_attended_result|
          @combine_results[i][0] = not_attended_result.categoryexamId
          @combine_results[i][1] = not_attended_result.name
          @combine_results[i][2] = not_attended_result.examType
          @combine_results[i][3] = not_attended_result.categoryuserId
          @combine_results[i][4] = not_attended_result.username
          @combine_results[i][5] = not_attended_result.attempt
          @combine_results[i][6] = not_attended_result.total_mark
          @combine_results[i][7] = "-"
          @combine_results[i][8] = "-"
          @combine_results[i][9] = "#{t('result.not_attended')}"
          @combine_results[i][10] = "-"
          @combine_results[i][11] = 0 #has_attended status has been set to 0
          i += 1
        end
      end
      
      unless @not_completed_results.blank?
        @not_completed_results.each do |not_completed_result|
          @combine_results[i][0] = not_completed_result.categoryexamId
          @combine_results[i][1] = not_completed_result.name
          @combine_results[i][2] = not_completed_result.examType
          @combine_results[i][3] = not_completed_result.categoryuserId
          @combine_results[i][4] = not_completed_result.username
          @combine_results[i][5] = not_completed_result.attempt
          @combine_results[i][6] = not_completed_result.total_mark
          @combine_results[i][7] = "-"
          @combine_results[i][8] = "-"
          @combine_results[i][9] = "#{t('result.not_properly_attended')}"
          @combine_results[i][10] = "-"
          @combine_results[i][11] = 1 #has_attended status has been set to 1
          i += 1
        end
      end
      
      @sort_exam_IDs = []
      
      unless @attended_results.blank?
        @attended_results.each do |attended_result|
          @sort_exam_IDs << attended_result.categoryexamId
        end
      end

      unless @not_attended_results.blank?
        @not_attended_results.each do |not_attended_result|
          @sort_exam_IDs << not_attended_result.categoryexamId
        end
      end

      unless @not_completed_results.blank?
        @not_completed_results.each do |not_completed_result|
          @sort_exam_IDs << not_completed_result.categoryexamId
        end
      end
   
      @sort_exam_IDs = @sort_exam_IDs.sort
    render :layout => false
 end
 
   def examsResult
    @c = Category.where(['organization_id = ?',@organization_id])
    @category_id = params[:examCategory].to_i
    @yrs = Array.new(10){|i| Date.current.year-i}
    @examTypes = Examtype.where(['organization_id = ?',@organization_id])
    unless @category_id == 0
      @academicYear = params[:academicYear].to_i
      @examtype = params[:examtype].to_i
      @category_exam = Categoryexam.where(["category_id = ? and currentyear = ? and examtype_id = ?",@category_id,@academicYear,@examtype])
    end 
    
  end
  
  def viewExamResult
     exam = params[:exam_id].to_i
     semesterId = params[:semester_id].to_i
     category_id = params[:category_id].to_i
     academicYear = params[:currentyear].to_i
     examtype = params[:examType]
    sql = "SELECT S.id as examid, U.id, U.name,U.login,U.is_temp_examinee as tempexaminee,Q.attempt,E.total_mark,E.score,E.percent,E.status,E.result_pending  
    From exam_results E
    Inner Join categoryexamusers Q on E.categoryuser_id = Q.categoryuser_id
     AND  E.categoryexam_id = Q.categoryexam_id AND E.attempt = Q.attempt
    Inner Join categoryexams C on E.categoryexam_id = C.id
    Inner Join categoryusers D on E.categoryuser_id = D.id
    Inner Join categories F on C.category_id = F.id
    Inner Join exams S on C.exam_id = S.id
    Inner Join users U on D.user_id = U.id
    Inner Join examtypes Y on C.examtype_id = Y.id
    
    where S.id = #{exam} and C.category_id= #{category_id} and C.currentyear = #{academicYear}  and C.examtype_id = #{examtype}
    group by S.id, U.id, U.name,Q.attempt,E.total_mark,E.score,E.percent,E.status;"
 
       @results = Evaluation.find_by_sql(sql)
       render :layout => false
  end
  
  def departmentResult
    @c = Category.where(['organization_id = ?',@organization_id])
    @category_id = params[:examCategory].to_i
    @yrs = Array.new(10){|i| Date.current.year-i}
    @examTypes = Examtype.where(['organization_id = ?',@organization_id])
    
   examCategory = params[:examCategory].to_i
   academicyear = params[:academicYear].to_i
   examtype = params[:examtype].to_i
   @examCategory = params[:examCategory].to_i
   @academicyear = params[:academicYear].to_i
   @examtype = params[:examtype].to_i
    
    @category = params[:examCategory].to_i
      unless params[:examCategory].to_i == 0
        
         if @organization_id == 1
          subjects = "SELECT  Distinct S.name as examname, S.total_mark as totalMark
            From exam_results E
            Inner Join categoryexams C on E.categoryexam_id = C.id
            Inner Join categoryusers D on E.categoryuser_id = D.id
            Inner Join categories F on C.category_id = F.id
            Inner Join exams S on C.exam_id = S.id
            Inner Join users U on D.user_id = U.id
            Inner Join courses M on F.course_id = M.id
            Inner Join sections N on F.section_id = N.id
            Inner Join examtypes Y on C.examtype_id = Y.id
            where F.id = #{examCategory} and C.category_id = F.id and C.currentyear = #{academicyear} and Y.id = #{examtype};"
          
           @examHeaders = ExamResult.find_by_sql(subjects)

          users = "SELECT  Distinct U.id as userId, U.name as username,U.login,U.is_temp_examinee as tempexaminee, F.id as categoryId, M.name as coursename, N.name as section
            From exam_results E
            Inner Join categoryexams C on E.categoryexam_id = C.id
            Inner Join categoryusers D on E.categoryuser_id = D.id
            Inner Join categories F on C.category_id = F.id
            Inner Join exams S on C.exam_id = S.id
            Inner Join users U on D.user_id = U.id
            Inner Join courses M on F.course_id = M.id
            Inner Join sections N on F.section_id = N.id
            Inner Join examtypes Y on C.examtype_id = Y.id
            where F.id = #{examCategory} and C.category_id = F.id and C.currentyear = #{academicyear}  and Y.id = #{examtype};"
       
          @userIds = ExamResult.find_by_sql(users)
         end  
        
        
        if @organization_id == 2
          subjects = "SELECT  Distinct S.name as examname, S.total_mark as totalMark
          From exam_results E
          Inner Join categoryexams C on E.categoryexam_id = C.id
          Inner Join categoryusers D on E.categoryuser_id = D.id
          Inner Join categories F on C.category_id = F.id
          Inner Join exams S on C.exam_id = S.id
          Inner Join users U on D.user_id = U.id
          Inner Join academic_years A on F.academic_year_id = A.id
          Inner Join courses M on F.course_id = M.id
          Inner Join departments N on F.department_id = N.id
          Inner Join semesters P on F.semester_id = P.id
          Inner Join examtypes Y on C.examtype_id = Y.id
          where F.id = #{examCategory} and C.category_id = F.id and C.currentyear = #{academicyear} and Y.id = #{examtype};"
          
          @examHeaders = ExamResult.find_by_sql(subjects)

         users = "SELECT  Distinct U.id as userId, U.name as username,U.login,U.is_temp_examinee as tempexaminee, F.id as categoryId, M.name as coursename,A.name as AcademicYear
          From exam_results E
          Inner Join categoryexams C on E.categoryexam_id = C.id
          Inner Join categoryusers D on E.categoryuser_id = D.id
          Inner Join categories F on C.category_id = F.id
          Inner Join exams S on C.exam_id = S.id
          Inner Join users U on D.user_id = U.id
          Inner Join academic_years A on F.academic_year_id = A.id
          Inner Join courses M on F.course_id = M.id
          Inner Join departments N on F.department_id = N.id
          Inner Join semesters P on F.semester_id = P.id
          Inner Join examtypes Y on C.examtype_id = Y.id
          where F.id = #{examCategory} and C.category_id = F.id and C.currentyear = #{academicyear}  and Y.id = #{examtype};"
       
          @userIds = ExamResult.find_by_sql(users)
        end
      
        if @organization_id == 3 or @organization_id == 4
          subjects = "SELECT  Distinct S.name as examname, S.total_mark as totalMark
              From exam_results E
              Inner Join categoryexams C on E.categoryexam_id = C.id
              Inner Join categoryusers D on E.categoryuser_id = D.id
              Inner Join categories F on C.category_id = F.id
              Inner Join exams S on C.exam_id = S.id
              Inner Join users U on D.user_id = U.id
              Inner Join departments N on F.department_id = N.id
              Inner Join examtypes Y on C.examtype_id = Y.id
              where F.id = #{examCategory} and C.category_id = F.id and C.currentyear = #{academicyear} and Y.id = #{examtype};"
          
          @examHeaders = ExamResult.find_by_sql(subjects)

         users = "SELECT  Distinct U.id as userId, U.name as username,U.login,U.is_temp_examinee as tempexaminee, F.id as categoryId, N.name as department
            From exam_results E
            Inner Join categoryexams C on E.categoryexam_id = C.id
            Inner Join categoryusers D on E.categoryuser_id = D.id
            Inner Join categories F on C.category_id = F.id
            Inner Join exams S on C.exam_id = S.id
            Inner Join users U on D.user_id = U.id
            Inner Join departments N on F.department_id = N.id
            Inner Join examtypes Y on C.examtype_id = Y.id
            where F.id = #{examCategory} and C.category_id = F.id and C.currentyear = #{academicyear}  and Y.id = #{examtype};"
       
          @userIds = ExamResult.find_by_sql(users)          
         end      
    end  
  end
  
  def viewDepartmentResult
    category_id = params[:category_id].to_i
    
    if @organization_id == 1
    subjects = "SELECT  Distinct S.name as examname
    From exam_results E
    Inner Join categoryexams C on E.categoryexam_id = C.id
    Inner Join categoryusers D on E.categoryuser_id = D.id
    Inner Join categories F on C.category_id = F.id
    Inner Join exams S on C.exam_id = S.id
    Inner Join users U on D.user_id = U.id
    Inner Join courses M on F.course_id = M.id
    Inner Join sections N on F.section_id = N.id
    where F.id = #{category_id} and C.category_id = F.id;"
    
    @examHeaders = ExamResult.find_by_sql(subjects)

   users = "SELECT  Distinct U.id as userId, U.name as username, F.id as categoryId, M.name as coursename, N.name as section
    From exam_results E
    Inner Join categoryexams C on E.categoryexam_id = C.id
    Inner Join categoryusers D on E.categoryuser_id = D.id
    Inner Join categories F on C.category_id = F.id
    Inner Join exams S on C.exam_id = S.id
    Inner Join users U on D.user_id = U.id
    Inner Join courses M on F.course_id = M.id
    Inner Join sections N on F.section_id = N.id
    where F.id = #{category_id} and C.category_id = F.id;"
 
    @userIds = ExamResult.find_by_sql(users)   
    render :layout => false
    end    
    
    if @organization_id == 2
    subjects = "SELECT  Distinct S.name as examname
    From exam_results E
    Inner Join categoryexams C on E.categoryexam_id = C.id
    Inner Join categoryusers D on E.categoryuser_id = D.id
    Inner Join categories F on C.category_id = F.id
    Inner Join exams S on C.exam_id = S.id
    Inner Join users U on D.user_id = U.id
    Inner Join academic_years A on F.academic_year_id = A.id
    Inner Join courses M on F.course_id = M.id
    Inner Join departments N on F.department_id = N.id
   Inner Join semesters P on F.semester_id = P.id
    where F.id = #{category_id} and C.category_id = F.id;"
    
    @examHeaders = ExamResult.find_by_sql(subjects)

   users = "SELECT  Distinct U.id as userId, U.name as username, F.id as categoryId, M.name as coursename,A.name as AcademicYear
    From exam_results E
    Inner Join categoryexams C on E.categoryexam_id = C.id
    Inner Join categoryusers D on E.categoryuser_id = D.id
    Inner Join categories F on C.category_id = F.id
    Inner Join exams S on C.exam_id = S.id
    Inner Join users U on D.user_id = U.id
    Inner Join academic_years A on F.academic_year_id = A.id
    Inner Join courses M on F.course_id = M.id
    Inner Join departments N on F.department_id = N.id
   Inner Join semesters P on F.semester_id = P.id
    where F.id = #{category_id} and C.category_id = F.id;"
 
    @userIds = ExamResult.find_by_sql(users)   
    render :layout => false
  end
  
    if @organization_id == 3 or @organization_id == 4
    subjects = "SELECT  Distinct S.name as examname
    From exam_results E
    Inner Join categoryexams C on E.categoryexam_id = C.id
    Inner Join categoryusers D on E.categoryuser_id = D.id
    Inner Join categories F on C.category_id = F.id
    Inner Join exams S on C.exam_id = S.id
    Inner Join users U on D.user_id = U.id
    Inner Join departments N on F.department_id = N.id
    where F.id = #{category_id} and C.category_id = F.id;"
    
    @examHeaders = ExamResult.find_by_sql(subjects)

   users = "SELECT  Distinct U.id as userId, U.name as username, F.id as categoryId, N.name as department
    From exam_results E
    Inner Join categoryexams C on E.categoryexam_id = C.id
    Inner Join categoryusers D on E.categoryuser_id = D.id
    Inner Join categories F on C.category_id = F.id
    Inner Join exams S on C.exam_id = S.id
    Inner Join users U on D.user_id = U.id
    Inner Join departments N on F.department_id = N.id
    where F.id = #{category_id} and C.category_id = F.id;"
 
    @userIds = ExamResult.find_by_sql(users)    
    render :layout => false
    end
  
  end

end

class TwoDimArray
  attr_reader :hash

  def initialize
    @hash = {}
  end

  def [](key)
    hash[key] ||= {}
  end

  def rows
    hash.length   
  end

  alias_method :length, :rows
end
