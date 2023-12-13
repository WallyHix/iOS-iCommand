//
//  AssistantsViewModel.swift
//  ConversAI
//
//  Created by Murat ÖZTÜRK on 7.06.2023.
//

import Foundation

class AssistantsViewModel: ObservableObject {
    
    @Published var  assistantList = [AiAssistantsModel]()
    @Published var  showVertical = Bool()
    @Published var  selectedValue = String()
    @Published var  verticalShowList = [AiAssistantModel]()
    
    
    init()
    {
        loadData()
    }
    
    func loadData(){
        DispatchQueue.main.async {
            self.assistantList = [
            AiAssistantsModel(title: "writing", assistant: [
                AiAssistantModel(
                    image: "memo",
                    color: .pastelGreen,
                    name: "write_article",
                    description: "write_article_description",
                    role: Constants.Writing.WRITE_ARTICLE,
                    example: [
                        "write_article_example1",
                        "write_article_example2",
                        "write_article_example3"
                    ]
                ),
                AiAssistantModel(
                    image: "cap",
                    color: .pastelBlue,
                    name: "academic_writer",
                    description: "academic_writer_description",
                    role: Constants.Writing.ACADEMIC_WRITER,
                    example: [
                        "academic_writer_example1",
                        "academic_writer_example2",
                        "academic_writer_example3"
                    ]
                ),
                AiAssistantModel(
                    image: "page_facing_up",
                    color: .pastelRed,
                    name: "summarize",
                    description: "summarize_description",
                    role: Constants.Writing.SUMMARIZE,
                    example: [
                        "summarize_example1",
                        "summarize_example2",
                        "summarize_example3"
                    ]
                ),
                AiAssistantModel(
                    image: "earth",
                    color: .pastelOrange,
                    name: "translate_language",
                    description: "translate_language_description",
                    role: Constants.Writing.TRANSLATE_LANGUAGE,
                    example: [
                        "translate_language_example1",
                        "translate_language_example2",
                        "translate_language_example3"
                    ]
                ),
                AiAssistantModel(
                    image: "search",
                    color: .pastelPink,
                    name: "plagiarism_checker",
                    description: "plagiarism_checker_description",
                    role: Constants.Writing.PLAGIARISM_CHECKER,
                    example: [
                        "plagiarism_checker_example1",
                        "plagiarism_checker_example2",
                        "plagiarism_checker_example3"
                    ]
                ),
            ]),
            AiAssistantsModel(
                title: "creative",
                assistant: [
                    AiAssistantModel(
                        image: "musical",
                        color: .pastelYellow,
                        name: "song_lyrics",
                        description: "song_lyrics_description",
                        role: Constants.Creative.SONG_LYRICS,
                        example: [
                            "song_lyrics_example1",
                            "song_lyrics_example2",
                            "song_lyrics_example3"
                        ]
                    ),
                    AiAssistantModel(
                        image: "open_book",
                        color: .pastelAqua,
                        name: "storyteller",
                        description: "storyteller_description",
                        role: Constants.Creative.STORYTELLER,
                        example: [
                            "storyteller_example1",
                            "storyteller_example2",
                            "storyteller_example3"
                        ]
                    ),
                    AiAssistantModel(
                        image: "scroll",
                        color: .pastelGreen,
                        name: "poems",
                        description: "poems_description",
                        role: Constants.Creative.POEMS,
                        example: [
                            "poems_example1",
                            "poems_example2",
                            "poems_example3"
                        ]
                    ),
                    AiAssistantModel(
                        image: "clapper",
                        color: .pastelPink,
                        name: "movie_script",
                        description: "movie_script_description",
                        role: Constants.Creative.MOVIE_SCRIPT,
                        example: [
                            "movie_script_example1",
                            "movie_script_example2",
                            "movie_script_example3"
                        ]
                    )
                ]
            ),
            AiAssistantsModel(
                title: "business",
                assistant: [
                    AiAssistantModel(
                        image: "envelope",
                        color: .pastelPurple,
                        name: "email_writer",
                        description: "email_writer_description",
                        role: Constants.Business.EMAIL_WRITER,
                        example: [
                            "email_writer_example1",
                            "email_writer_example2",
                            "email_writer_example3"
                        ]
                    ),
                    AiAssistantModel(
                        image: "page_with_curl",
                        color: .pastelOrange,
                        name: "answer_interviewer",
                        description: "answer_interviewer_description",
                        role: Constants.Business.ANSWER_INTERVIEWER,
                        example: [
                            "answer_interviewer_example1",
                            "answer_interviewer_example2",
                            "answer_interviewer_example3"
                        ]
                    ),
                    AiAssistantModel(
                        image: "briefcase",
                        color: .pastelLilac,
                        name: "job_post",
                        description: "job_post_description",
                        role: Constants.Business.JOB_POST,
                        example: [
                            "job_post_example1",
                            "job_post_example2",
                            "job_post_example3"
                        ]
                    ),
                    AiAssistantModel(
                        image: "star",
                        color: .pastelAqua,
                        name: "advertisement",
                        description: "advertisement_description",
                        role: Constants.Business.ADVERTISEMENT,
                        example: [
                            "advertisement_example1",
                            "advertisement_example2",
                            "advertisement_example3"
                        ]
                    )
                ]
            ),
            AiAssistantsModel(
                title: "social_media",
                assistant: [
                    AiAssistantModel(
                        image: "linkedin",
                        color: .pastelAqua,
                        name: "linkedin",
                        description: "linkedin_description",
                        role: Constants.SocialMedia.LINKEDIN,
                        example: [
                            "linkedin_example1",
                            "linkedin_example2",
                            "linkedin_example3"
                        ]
                    ),
                    AiAssistantModel(
                        image: "instagram",
                        color: .pastelYellow,
                        name: "instagram",
                        description: "instagram_description",
                        role: Constants.SocialMedia.INSTAGRAM,
                        example: [
                            "instagram_example1",
                            "instagram_example2",
                            "instagram_example3"
                        ]
                    ),
                    AiAssistantModel(
                        image: "twitter",
                        color: .pastelBlue,
                        name: "twitter",
                        description: "twitter_description",
                        role: Constants.SocialMedia.TWITTER,
                        example: [
                            "twitter_example1",
                            "twitter_example2",
                            "twitter_example3"
                        ]
                    ),
                    AiAssistantModel(
                        image: "tiktok",
                        color: .pastelTeal,
                        name: "tiktok",
                        description: "tiktok_description",
                        role: Constants.SocialMedia.TIKTOK,
                        example: [
                            "tiktok_example1",
                            "tiktok_example2",
                            "tiktok_example3"
                        ]
                    ),
                    AiAssistantModel(
                        image: "facebook",
                        color: .pastelLavender,
                        name: "facebook",
                        description: "facebook_description",
                        role: Constants.SocialMedia.FACEBOOK,
                        example: [
                            "facebook_example1",
                            "facebook_example2",
                            "facebook_example3"
                        ]
                    )
                ]
            ),
            AiAssistantsModel(
                title: "developer",
                assistant: [
                    AiAssistantModel(
                        image: "laptop",
                        color: .pastelGreen,
                        name: "write_code",
                        description: "write_code_description",
                        role: Constants.Developer.WRITE_CODE,
                        example: [
                            "write_code_example1",
                            "write_code_example2",
                            "write_code_example3"
                        ]
                    ),
                    AiAssistantModel(
                        image: "puzzle",
                        color: .pastelRed,
                        name: "explain_code",
                        description: "explain_code_description",
                        role: Constants.Developer.EXPLAIN_CODE,
                        example: [
                            "explain_code_example1",
                            "explain_code_example2",
                            "explain_code_example3"
                        ]
                    )
                ]
            ),
            AiAssistantsModel(
                title: "personal",
                assistant: [
                    AiAssistantModel(
                        image: "cake",
                        color: .pastelYellow,
                        name: "birtday",
                        description: "birtday_description",
                        role: Constants.Personal.BIRTHDAY,
                        example: [
                            "birtday_example1",
                            "birtday_example2",
                            "birtday_example3"
                        ]
                    ),
                    AiAssistantModel(
                        image: "gift",
                        color: .pastelCoral,
                        name: "apology",
                        description: "apology_description",
                        role: Constants.Personal.APOLOGY,
                        example: [
                            "apology_example1",
                            "apology_example2",
                            "apology_example3"
                        ]
                    ),
                    AiAssistantModel(
                        image: "envelope_arrow",
                        color: .pastelBlue,
                        name: "invitation",
                        description: "invitation_description",
                        role: Constants.Personal.INVITATION,
                        example: [
                            "invitation_example1",
                            "invitation_example2",
                            "invitation_example3"
                        ]
                    )
                ]
            ),
            AiAssistantsModel(
                title: "other",
                assistant: [
                    AiAssistantModel(
                        image: "balloon",
                        color: .pastelPink,
                        name: "create_conversation",
                        description: "create_conversation_description",
                        role: Constants.Other.CREATE_CONVERSATION,
                        example: [
                            "create_conversation_example1",
                            "create_conversation_example2",
                            "create_conversation_example3"
                        ]
                    ),
                    AiAssistantModel(
                        image: "laugh",
                        color: .pastelLavender,
                        name: "tell_joke",
                        description: "tell_joke_description",
                        role: Constants.Other.TELL_JOKE,
                        example: [
                            "tell_joke_example1",
                            "tell_joke_example2",
                            "tell_joke_example3"
                        ]
                    ),
                    AiAssistantModel(
                        image: "food",
                        color: .pastelRed,
                        name: "food_recipes",
                        description: "food_recipes_description",
                        role: Constants.Other.FOOD_RECIPES,
                        example: [
                            "food_recipes_example1",
                            "food_recipes_example2",
                            "food_recipes_example3"
                        ]
                    ),
                    AiAssistantModel(
                        image: "leafy",
                        color: .pastelGreen,
                        name: "diet_plan",
                        description: "diet_plan_description",
                        role: Constants.Other.DIET_PLAN,
                        example: [
                            "diet_plan_example1",
                            "diet_plan_example2",
                            "diet_plan_example3"
                        ]
                    )
                ]
            )
        ]
        }
    }
    
}
