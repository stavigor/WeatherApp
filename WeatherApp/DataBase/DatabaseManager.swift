//
//  DatabaseManager.swift
//  WeatherApp
//
//  Created by Игорь Растегаев on 27.09.2023.
//

import UIKit
import CoreData

class DatabaseManager {
    static let shared = DatabaseManager()
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func saveContext() {
        do {
            try context.save()
            print("Saving success!")
        }catch {
            print("Saving error:", error)
        }
    }
    
    func clearEntity(entityName: String){
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Clear entity error:", error)
        }
    }
    
    //MARK: - Today weather handling
    func addTodayWeather(_ todayModel: TodayWeatherModel) {
        let todayEntity = TodayEntity(context: context)
        addUpdateTodayWeather(todayEntity: todayEntity, todayModel: todayModel)
    }
    
    func updateTodayWeather(todayModel: TodayWeatherModel, todayEntity: TodayEntity) {
        addUpdateTodayWeather(todayEntity: todayEntity, todayModel: todayModel)
    }
    
    private func addUpdateTodayWeather(todayEntity: TodayEntity, todayModel: TodayWeatherModel) {
        clearEntity(entityName: "TodayEntity")
        todayEntity.cityName = todayModel.city
        todayEntity.temp = todayModel.tempString
        todayEntity.weatherID = Int32(todayModel.id)
        saveContext()
    }
    
    func fetchTodayWeather() -> TodayEntity {
        var todayEntities: [TodayEntity] = []
        do {
            todayEntities = try context.fetch(TodayEntity.fetchRequest())
        } catch {
            print("Fetch results error", error)
        }
        return todayEntities.last ?? TodayEntity()
    }
    
    
//    //MARK: - Invoice manage
//    private func addUpdateResume(resumeEntity: Resume, resume: ResumeModel) {
//        let userDefaults = UserDefaults.standard
//        let resumeCount = userDefaults.integer(forKey: "resumeCount")
//        resumeEntity.name = "Resume #\(resumeCount + 1)"
//        
//        resumeEntity.createDate = Date()
//        resumeEntity.summary = resume.summary
//        
//        let profile = resume.profile
//        let profileEntity = Profile(context: context)
//        profileEntity.firstName = profile.firstName
//        profileEntity.lastName = profile.lastName
//        profileEntity.email = profile.email
//        profileEntity.number = profile.number
//        profileEntity.address = profile.address
//        profileEntity.website = profile.website
//        profileEntity.resume = resumeEntity
//        resumeEntity.profile = profileEntity
//        
//        for work in resume.workExpierence {
//            let workEntity = Work(context: context)
//            workEntity.companyName = work.companyName
//            workEntity.companyLocation = work.companyLocation
//            workEntity.descr = work.description
//            workEntity.endDate = work.endDate
//            workEntity.startDate = work.startDate
//            workEntity.position = work.position
//            
//            workEntity.resume = resumeEntity
//            resumeEntity.addToWorkExpierence(workEntity)
//        }
//        
//        for edu in resume.educations {
//            let eduEntity = Edication(context: context)
//            eduEntity.institutionName = edu.institutionName
//            eduEntity.fieldOfStudy = edu.fieldOfStudy
//            eduEntity.degree = edu.degree
//            eduEntity.endDate = edu.endDate
//            eduEntity.startDate = edu.startDate
//            
//            eduEntity.resume = resumeEntity
//            resumeEntity.addToEdications(eduEntity)
//        }
//        
//        for hard in resume.hardSkills {
//            let eduEntity = HardSkills(context: context)
//            eduEntity.skillName = hard.skillName
//            eduEntity.skillLevel = hard.skillLevel
//            
//            eduEntity.resume = resumeEntity
//            resumeEntity.addToHardSkills(eduEntity)
//        }
//        
//        for soft in resume.softSkills {
//            let softEntity = SoftSkills(context: context)
//            softEntity.skillName = soft.skillName
//            
//            softEntity.resume = resumeEntity
//            resumeEntity.addToSoftSkills(softEntity)
//        }
//        
//        userDefaults.set(resumeCount + 1, forKey: "resumeCount")
//        saveContext()
//    }
//    
//    func addResume(_ resume: ResumeModel) {
//        dump(resume)
//        
//        let resumeEntity = Resume(context: context)
//        addUpdateResume(resumeEntity: resumeEntity, resume: resume)
//    }
//    
//    func fetchResume() -> [Resume] {
//        var resumeEntities: [Resume] = []
//        do {
//            resumeEntities = try context.fetch(Resume.fetchRequest())
//            print("resumeEntities", resumeEntities)
//        }catch {
//            print("Fetch results error", error)
//        }
//        return resumeEntities.reversed()
//    }
//    
//    func deleteResume(resumeEntity: Resume) {
//        context.delete(resumeEntity)
//        saveContext()
//    }
//    
//    func transformResume(_ resumeEntity: Resume) -> ResumeModel{
//        let resume = ResumeModel()
//        resume.summary = resumeEntity.summary ?? ""
//        resume.profile = transformProfile(resumeEntity.profile!)
//        resume.workExpierence = transformWork(resumeEntity.workExpierence!)
//        resume.educations = transformEducation(resumeEntity.edications!)
//        resume.hardSkills = transformHards(resumeEntity.hardSkills!)
//        resume.softSkills = transformSofts(resumeEntity.softSkills!)
//        
//        return resume
//    }
//    
//    //MARK: - Transorm manage
//    func transformWork(_ workEntity: NSSet) -> [WorkModel]{
//        var works = [WorkModel]()
//        for entity in Array(workEntity) as! [Work] {
//            let work = WorkModel()
//            work.companyName = entity.companyName ?? ""
//            work.companyLocation = entity.companyLocation ?? ""
//            work.endDate = entity.endDate ?? Date()
//            work.startDate = entity.startDate ?? Date()
//            work.position = entity.position ?? ""
//            works.append(work)
//        }
//        return works
//    }
//    
//    func transformEducation(_ eduEntity: NSSet) -> [EducationModel]{
//        var educations = [EducationModel]()
//        for entity in Array(eduEntity) as! [Edication] {
//            let education = EducationModel()
//            education.institutionName = entity.institutionName ?? ""
//            education.fieldOfStudy = entity.fieldOfStudy ?? ""
//            education.endDate = entity.endDate ?? Date()
//            education.startDate = entity.startDate ?? Date()
//            education.degree = entity.degree ?? ""
//            educations.append(education)
//        }
//        return educations
//    }
//    
//    func transformHards(_ hardEntity: NSSet) -> [HardSkillModel]{
//        var hards = [HardSkillModel]()
//        for entity in Array(hardEntity) as! [HardSkills] {
//            let hard = HardSkillModel()
//            hard.skillName = entity.skillName ?? ""
//            hard.skillLevel = entity.skillLevel ?? ""
//            hards.append(hard)
//        }
//        return hards
//    }
//    
//    func transformSofts(_ softEntity: NSSet) -> [SoftSkillModel]{
//        var softs = [SoftSkillModel]()
//        for entity in Array(softEntity) as! [SoftSkills] {
//            let soft = SoftSkillModel()
//            soft.skillName = entity.skillName ?? ""
//            softs.append(soft)
//        }
//        return softs
//    }
}
