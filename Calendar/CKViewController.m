#import <CoreGraphics/CoreGraphics.h>
#import "CKViewController.h"
#import "CKCalendarView.h"

@interface CKViewController () <CKCalendarDelegate>

@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
/** 显示的最小日期*/
@property(nonatomic, strong) NSDate *minimumDate;
/** 显示的最大日期*/
@property (nonatomic, strong)NSDate *maxmumDate;
/** 不可以预约的日期*/
@property(nonatomic, strong) NSArray *disabledDates;
/** 可以接受预约的日期数组*/
@property (nonatomic, strong)NSArray *appointmentAcceptDates;

@end

@implementation CKViewController

- (id)init {
    self = [super init];
    if (self) {
        CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
        self.calendar = calendar;
        calendar.delegate = self;
        calendar.dayTitle = @"可预约";
        calendar.topTitle = @"可预约时间";
        
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
        self.minimumDate = [self.dateFormatter dateFromString:@"20/01/2016"];
        self.maxmumDate = [self.dateFormatter dateFromString:@"20/07/2016"];
        self.appointmentAcceptDates = @[
                [self.dateFormatter dateFromString:@"05/05/2016"],
                [self.dateFormatter dateFromString:@"06/05/2016"],
                [self.dateFormatter dateFromString:@"07/05/2016"]
        ];

        calendar.onlyShowCurrentMonth = NO;
        calendar.adaptHeightToNumberOfWeeksInMonth = YES;

        calendar.frame = CGRectMake(10, 10, 300, 320);
        [self.view addSubview:calendar];

        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(calendar.frame) + 4, self.view.bounds.size.width, 24)];
        [self.view addSubview:self.dateLabel];

        self.view.backgroundColor = [UIColor whiteColor];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)localeDidChange {
    [self.calendar setLocale:[NSLocale currentLocale]];
}

- (BOOL)dateIsDisabled:(NSDate *)date {
    for (NSDate *disabledDate in self.disabledDates) {
        if ([disabledDate isEqualToDate:date]) {
            return YES;
        }
    }
    return NO;
}

/** 是否可以被预约*/
- (BOOL)isAcceptedForAppointment:(NSDate *)date {
    for (NSDate *appointmentAcceptDate in self.appointmentAcceptDates) {
        if ([date isEqualToDate:appointmentAcceptDate]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark -
#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem dateButton:(DateButton *)dateButton forDate:(NSDate *)date {
    // TODO: play with the coloring if we want to...
    if ([self isAcceptedForAppointment:date]) {
        dateItem.backgroundColor = kBackgroundBlueColor;
        dateItem.textColor = kLightBlueColor;
        dateItem.titleColor = kLightBlueColor;
        dateButton.hiddenTitleLable = NO;
        dateButton.layer.borderColor = kLightBlueColor.CGColor;
        dateButton.layer.borderWidth = 1;
        dateButton.layer.cornerRadius = 4.0f;
    }else  {
        dateButton.layer.borderWidth = 0;
        dateButton.hiddenTitleLable = YES;
    }
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    return [self isAcceptedForAppointment:date];
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    self.dateLabel.text = [self.dateFormatter stringFromDate:date];
    NSLog(@"选中了某一天");
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    if ([date laterDate:self.minimumDate] == date && [date earlierDate:self.maxmumDate] == date) {
//        self.calendar.backgroundColor = [UIColor blueColor];
        return YES;
    } else {
//        self.calendar.backgroundColor = [UIColor redColor];
        return NO;
    }
}
- (BOOL)calendar:(CKCalendarView *)calendar willDeselectDate:(NSDate *)date {
    return NO;
}
- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
    NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
}

@end